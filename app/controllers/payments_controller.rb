class PaymentsController < ApplicationController
  layout "form_page"
  before_filter :authenticate_user!, except: [:stripe_webhooks]
  protect_from_forgery except: [:stripe_webhooks]
  before_filter :check_user_expiration, only: [:cancel_subscription]

  skip_before_filter :redirect_to_payment

  def new
    @amount = current_user.try(:membership_fee)["amount"]
  end

  def create
    plan_type = current_user.membership_fee
    super_admin = nil
    User.all.each do |user|
      if user.super_admin?
        super_admin = user;
      end
    end

    begin
      customer = Stripe::Customer.create({
        :email => params[:stripeEmail],
        :source  => params[:stripeToken],
      },{:stripe_account => super_admin.stripe_user_id})

      plan = Stripe::Plan.retrieve({
        :id => plan_type["id"]
      },{:stripe_account => super_admin.stripe_user_id})

      subscription = Stripe::Subscription.create({
        :customer => customer.id,
        :plan => plan.id,
        :application_fee_percent => 5.58,
      }, :stripe_account => super_admin.stripe_user_id)

      user_subscriprion = current_user.subscriptions.create(
        :subscription_id => subscription.id,
        :customer_id => customer.id,
        :plan_id => plan.id
      )

      current_user.payments.create(
        :amount => plan_type['amount'], 
        :charge_id => subscription.id,
        :card_token => customer.id
      )

      if current_user.card.nil?
        current_user.create_card(
          customer_id: customer.id,
          card_token: customer.default_source
        )
      else
        current_user.card.update_attributes(
          customer_id: customer.id,
          card_token: customer.default_source
        )
      end

      flash[:notice] = 'Your subscription was successful'
      redirect_to dashboard_path
    rescue Stripe::StripeError => e
      flash[:error] = e.message
      redirect_to new_payment_path
    end
  end

  def cancel_subscription
    subscription_id = current_user.subscriptions.last.subscription_id
    super_admin = User.joins(:roles).where("roles.name = ?","super_admin")[0]
    begin
      subscription = Stripe::Subscription.retrieve({
        :id => subscription_id 
      },{:stripe_account => super_admin.stripe_user_id})
      subscription.delete
      current_user.update(expiration: nil)
    rescue Stripe::StripeError => e
      flash[:error] = e.message
    end
    redirect_to new_payment_path
  end

  def stripe_webhooks
    begin
      event_object = params[:data][:object]
      case params[:type]
       when 'invoice.payment_succeeded'
          handle_success_invoice event_object
        when 'invoice.payment_failed'
          handle_failure_invoice event_object
        when 'customer.subscription.deleted'
          handle_cancel_subscription event_object
      end
    rescue Exception => ex
      render json: {status: 422, error: "Webhook call failed"}
      return
    end
    render json: {status: 200}
  end

  def handle_success_invoice event_object
    stripe_sub = Stripe::Subscription.retrieve(event_object[:subscription],{stripe_account: params[:account]})
    subscription = Subscription.where(subscription_id: event_object[:subscription]).last
    if subscription.present? && subscription.user.present?
      user = subscription.user
      user.update(expiration: Date.today + 1.year)
      create_subscription(user, stripe_sub)
    end
  end

  def handle_failure_invoice event_object
    subscription = Subscription.where(subscription_id: event_object[:subscription]).last
    user = subscription.user if subscription.present?
  end

  def handle_cancel_subscription event_object
    subscription = Subscription.where(subscription_id: event_object[:id]).last
    if subscription.present? && subscription.user.present?
      user = subscription.user
      user.update(expiration: nil)
    end
  end

  def create_subscription(user, stripe_sub)
    user.subscriptions.create(subscription_id: stripe_sub[:id], customer_id: stripe_sub[:customer], plan_id: stripe_sub[:plan][:id])
  end

  private

  def check_user_expiration
    redirect_to dashboard_path if !current_user.paid?
  end

end
