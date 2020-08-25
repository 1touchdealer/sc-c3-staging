Rails.application.routes.draw do
  mount Rich::Engine => '/rich', :as => 'rich'
  devise_for :admin_users, ActiveAdmin::Devise.config.merge(
    class_name: 'User', as: 'admin',
    skip: [:confirmations, :passwords, :registrations, :unlocks, :omniauth_callbacks],
    controllers: {sessions: 'sessions'}
  )
  ActiveAdmin.routes(self)

  devise_for :users, :controllers => { registrations: 'registrations',
                                       sessions: 'sessions',
                                       :passwords => "passwords",
                                       omniauth_callbacks: "omniauth_callbacks" }

  root 'home#index'

  devise_scope :user do
    get '/users/sign_out' => 'sessions#destroy'
    get 'alliance_registration', :to => 'registrations#new_alliance'
    get 'business_registration', :to => 'registrations#new_business'
    get 'church_registration', :to => 'registrations#new_church'
    get 'alliance_edit', :to => 'registrations#edit_alliance'
    get 'business_edit', :to => 'registrations#edit_business'
    get 'church_edit', :to => 'registrations#edit_church'

    # get '/users/sign_up/alliance', :to => 'registrations#new_alliance'
    # get '/users/sign_up/business', :to => 'registrations#new_business'
    # get '/users/sign_up/church', :to => 'registrations#new_church'
    # get '/users/edit_alliance', :to => 'registrations#edit_alliance'
  end
  post 'stripe_webhooks' => 'payments#stripe_webhooks'
  get 'calendar' => 'events#index'
  resources :events,      only:  [:new, :create, :show] do
      resources :attendees,   only:  [:new, :create]
      resource :download_badges_pdf, only: [:show]
  end
  resources :alliances,   only:  [:index, :show, :edit, :update]
  resources :businesses,  only:  [:index, :show, :edit, :update]
  resources :churches,    only:  [:index, :show, :edit, :update]
  resources :users,       only:  [:edit, :update]
  resources :payments,    only:  [:new, :create]
  resources :ads,         only:  [:new, :create, :edit, :update]
  resources :invites,     only:  [:new, :create]
  resources :cards,       only:  [:new, :create, :edit, :update]

  resources :campaigns,   only:  [:index, :show, :new, :create] do
      resources :campaign_donations, only: [:new, :create]
  end

  resources :charitable_donations, only: [:new, :create]

  resources :chamber_donations, only: [:new, :create]

  resources :needs,       only: [:new, :create, :show] do
      resources :resources,          only: [:new, :create]
  end

  resources :resources,   only: [:new, :create] do
    get :accept, on: :member
  end

  # Subscription cancel
  get 'payments/cancel_subscription' , as: :cancel_subscription

  # Temporary Hidden
  # resources :job_leads, only: [:new, :create]

  get 'dashboard(/:user_id)' => 'users#dashboard', as: :dashboard

  #---------------- Tool Box Links ------------------
  get 'tool_boxes' => 'tool_boxes#index'
  get 'tool_box' => 'tool_boxes#show'

  get 'documents' => 'tool_boxes#documents'
  get 'tool_box_resources' => 'tool_boxes#resources'
  get 'tool_box_events' => 'tool_boxes#events'

  get 'blog' => 'tool_boxes#blog', as: :blog
  #--------------------------------------------------

  # #---------------- Invite  Links ------------------
  # get "invite/new" => 'invite#new', :as => :new_invite
  # post "invite/create" => 'invite#create', :as => :invites
  # #---------------------------------------------------

  get 'docs' => 'home#save_docs'

  get 'contact_us' =>  'contact_form#new'
  resources "contact_forms", only: [:new, :create]
end
