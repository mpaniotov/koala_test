Rails.application.routes.draw do
  devise_for :users

  match "/callback" => "facebook#callback", :via=>[:get,:post]
  match "/facebook_profile" => "facebook#facebook_profile", :via=>[:get,:post]
  root :to => 'facebook#index'
end
