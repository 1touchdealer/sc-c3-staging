class CardsController < ApplicationController
  layout "form_page"
  before_filter :authenticate_user!
  before_action :set_card, only: [:edit, :update]

  def new
    @card = Card.new
  end

  def create
    super_admin = User.joins(:roles).where("roles.name = ?","super_admin")[0]
    begin
      token = Stripe::Token.create(
        :card => {
          :number => params[:card_number],
          :exp_month => params[:date][:month],
          :exp_year => params[:date][:year],
          :cvc => params[:card_code],
          :name => params[:card_name],       
          :address_country=> params[:country],
          :address_line1=> params[:address1],
          :address_line2=> params[:address2],
          :address_city=> params[:city],
          :address_state=> params[:state],
          :address_zip=> params[:zip]
        }
      )
      customer = Stripe::Customer.create({
        :email => current_user.email,
        :source => token
      },{:stripe_account => super_admin.stripe_user_id})
      if customer.present?
        card = current_user.create_card(customer_id: customer.id, card_token: token.id)
        flash[:notice] = 'Successfully saved your card'
        redirect_to dashboard_path
      end
    rescue Stripe::StripeError => e
      flash[:error] = e.message
      render 'new'
    end
  end

  def edit
  end

  def update
    begin
      token = Stripe::Token.create(
        :card => {
          :number => params[:card_number],
          :exp_month => params[:date][:month],
          :exp_year => params[:date][:year],
          :cvc => params[:card_code],
          :name => params[:card_name],
          :address_country=> params[:country],
          :address_line1=> params[:address1],
          :address_line2=> params[:address2],
          :address_city=> params[:city],
          :address_state=> params[:state],
          :address_zip=> params[:zip]
        },
      )
      @customer.card = token.id
      if @customer.save
        @card.update_attributes(card_token: token.id)
      end
      flash[:notice] = 'Successfully saved your card'
      redirect_to dashboard_path
    rescue Stripe::StripeError => e
      flash[:error] = e.message
      redirect_to card_path(id: @card.id)
    end
  end

  private

    def set_card
      super_admin = User.joins(:roles).where("roles.name = ?","super_admin")[0]
      @card = Card.find(params[:id])
      @customer = Stripe::Customer.retrieve({
        :id => @card.customer_id 
      },{:stripe_account => super_admin.stripe_user_id})
      @stripe_card = @customer.sources.retrieve({
        :id => @customer.default_source 
      },{:stripe_account => super_admin.stripe_user_id})
    end
end
