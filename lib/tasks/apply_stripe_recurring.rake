task create_subscriptions: :environment do
  
  [{:email => "david.ballinger@opsourcestaffing.com",:customer => "cus_ARk2WlRSrR2kmr",:id => "individual-4900",:amount => 4900},
  {:email => "kmerkle@merittechnologies.com",:customer => "cus_CZp8DR23tSNmm9",:id => "business-29900",:amount => 29900}].each do |data|
    begin
      current_user = User.find_by_email(data[:email])

      token = Stripe::Token.create({
        :customer => data[:customer] ,
      },{:stripe_account => "acct_19hRtqDSjr9vEVhU"})

      customer = Stripe::Customer.create({
        :email => data[:email],
        :source  => token,
        },{:stripe_account => "acct_19hRtqDSjr9vEVhU"})

      plan = Stripe::Plan.retrieve({
        :id => data[:id]
      },{:stripe_account => "acct_19hRtqDSjr9vEVhU"})

      subscription = Stripe::Subscription.create({
        :customer => customer.id,
        :plan => plan.id,
        :application_fee_percent => 5.58,
      }, :stripe_account => "acct_19hRtqDSjr9vEVhU")

      user_subscriprion = current_user.subscriptions.create(
        :subscription_id => subscription.id,
        :customer_id => customer.id,
        :plan_id => plan.id
      )

      current_user.payments.create(
        :amount => data[:amount], 
        :charge_id => subscription.id,
        :card_token => customer.id
      )
    rescue Stripe::StripeError => e
      puts e.message
      puts data[:email]
    end
  end
  
end