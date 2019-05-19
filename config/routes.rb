Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'
  
  post 'tv/info'
  post 'tv/season'
  post 'tv/episode'
  post 'tv/credit'
  
  post 'movie/info'
  post 'movie/credit'

  post 'person/info'

  get 'movie/info', to: 'movie#get'
  get 'tv/info', to: 'tv#get_info'
  get 'tv/season', to: 'tv#get_season'
  get 'tv/episode', to: 'tv#get_episode'
  get 'person/info', to: 'person#get'
end
