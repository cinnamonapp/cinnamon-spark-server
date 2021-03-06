CinnamonSparkServer::Application.routes.draw do

  resources :ingredients

  resources :likes

  resources :comments

  # Users
  resources :users do
    # Has many meal records
    resources :meal_records

    resources :meals do
    end

    get 'week_view' => 'meals#week_view'

  end


  namespace :api, :defaults => { :format => :json } do
    namespace :v1 do

      resources :likes

      resources :users do
        resources :dashboard
      end

      namespace :fat_secret do
        resources :foods do
          get 'carbs_per_cup' => 'foods#carbs_per_cup'
          get 'carbs_per_servings' => 'foods#carbs_per_servings'
        end
      end

      resources :comments

      resources :meal_records do
        resources :comments
        resources :likes
      end
    end
  end

  get 'meal_records/estimate' => 'meal_records#estimate', as: 'meal_records_estimate'

  resources :meal_records

end
