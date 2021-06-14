Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    registrations: 'users/registrations' ,
                                  sessions: 'users/sessions'}
  get '/users/new'
  
  resources :users, only: [:show, :create, :update] do
    collection do 
      get 'user_value_set' => 'users#user_value_set'
    end
  end
  get '/game_events' => 'game_events#index', as: "game_events"
  resources :games do
    resources :game_events, only: [:new, :destroy, :show, :update, :edit],  as: "event" do
    end
    post 'game_events' => 'game_events#create', as: "game_events"
    post 'image_uploads' => 'game_events#image_upload'
  end
  post '/game_events' => 'game_events#game_events_create'
  get '/game_event_tags/autocomplete_tag_name'
  get "/search" => 'search#index'
  root 'games#index'
  get "/game_events/new" => 'game_events#game_events_new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
