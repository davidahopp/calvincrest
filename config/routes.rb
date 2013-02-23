Calvincrest::Application.routes.draw do


  mount Refinery::Core::Engine, :at => '/'


  # root :to => 'welcome#index'

end
