class AttendeesController < ApplicationController
  def new
    @event = Event.find(params[:event_id])
    @attendee = @event.attendees.new
    render layout: "form_page"
  end

  def create
    # fail_here
    @event = Event.find(params[:event_id])
    @attendee = @event.attendees.new(attendee_params)

    if current_user
      @attendee.user_id = current_user.id
      @attendee.email = current_user.email
      @attendee.name = current_user.name
    end

    if @attendee.valid?
      #Stripe: 2.9% plus 30 cent
      if params.has_key?(:stripeToken) and @attendee.attendance_level.cost > 0
        multiplier = @attendee.invitees.count + 1
        application_fee = ((@attendee.attendance_level.cost * 2.9 * multiplier) + 30).to_i

        super_admin = User.joins(:user_roles).where(user_roles:{role_id: Role.super_admin}).first

        begin
          customer = Stripe::Customer.create(
            :email => @attendee.email,
            :card  => params[:stripeToken])

          charge = Stripe::Charge.create(
            :customer    => customer.id,
            :amount      => @attendee.attendance_level.cost * 100 * multiplier,
            :description => 'Event Registration - ' + @event.name,
            :currency    => 'usd',
            :application_fee => application_fee, # amount in cents
            :destination => super_admin.stripe_user_id)

        rescue Stripe::CardError => e
          charge_error = e.message
        end
      end

      if charge_error
        render :new, layout: "form_page", notice: charge_error
      else
        if charge
          #-- Update Campaign Donation With Stripe Details
          @attendee.charge_id = charge.id
          @attendee.card_token = charge.source.id
          @attendee.paid = true
        end
        if @attendee.save
          redirect_to @event, notice: "Your attendance is confirmed for #{@event.name}"
        else
          render :new, layout: "form_page", notice: "There was an error confirming your attendance for #{@event.try(:name) || 'this event'}"
        end
      end
    else
      puts "ERRORS: ", @attendee.errors
      # flash[:error] = 'One or more errors in your Event Registration'
      render :new, layout: "form_page", notice: "One or more errors in your Event Registration"
    end

    # redirect_to @attendee.event
  end

  private
  def attendee_params
    params.require(:attendee).permit(:event_id, :user_id, :name, :email, :attendance_level_id, :paid, :charge_id, :card_token, invitees_attributes: [:name])
  end
end
