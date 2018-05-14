Rails.application.routes.draw do
  resources :quizzes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'quiz#index'
  
  get 'quiz/index'
  
  post 'quiz', to:'quiz#req'
end
