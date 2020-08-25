ActiveAdmin.register_page "ExpiredCards" do
  menu label: "Expired Cards"
  menu parent: "Users"

  controller do 
    def index
      @users = User.where('expiration < ?', Time.now).order('expiration DESC')
    end
  end

  content do
    render partial: 'expired_cards'
  end
end
