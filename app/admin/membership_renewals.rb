ActiveAdmin.register_page "Membership Renewals" do
  menu label: "Membership Renewals"
  menu parent: "Users"

  controller do 
    def index
      day = params[:day] || 7
      @users = User.where("DATE(expiration) <= ? AND DATE(expiration) >= ?", Date.today+day.to_i, Date.today).order('expiration')
      respond_to do |format|
        format.js
        format.html
      end
    end
  end

  content do
    render partial: 'membership_renewals'
  end

end
