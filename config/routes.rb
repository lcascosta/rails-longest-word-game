Rails.application.routes.draw do
  get 'game', to: 'gameplay#game'

  get 'score', to: 'gameplay#score'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
