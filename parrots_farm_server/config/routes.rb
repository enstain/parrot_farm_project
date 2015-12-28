Rails.application.routes.draw do

  root to: "parrots#index"
  resources :parrots do
  	collection do
  		get 'page/:page' => 'parrots#index'
  		get 'values/:field' => 'parrots#values'
  		get 'may_be_parents/:sex' => 'parrots#may_be_parents'
  	end
  	member do
  		get 'show_descendants' => 'parrots#show_descendants'
  		get 'show_ancestry' => 'parrots#show_ancestry'
  	end
  end

  match "*path", :to => "application#routing_error", :via => :all
end
