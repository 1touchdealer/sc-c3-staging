task move_customer_into_card: :environment do
  Subscription.all.each do |subscription|
    if subscription.user_id != 59
      Card.create(customer_id: subscription.customer_id,user_id: subscription.user_id)
    end
    if subscription.customer_id == "cus_CYJvh3IRyj15V1"
      Card.create(customer_id: subscription.customer_id,user_id: subscription.user_id)
    end
  end
end