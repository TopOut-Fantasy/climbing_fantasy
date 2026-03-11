require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  get "/api-docs", to: redirect("/scalar.html")
  mount Rswag::Api::Engine => "/api-docs"
  devise_for :admin_users, **ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users,
    path: "",
    path_names: { sign_in: "login", sign_out: "logout", sign_up: "register" },
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
      passwords: "users/passwords",
    }

  devise_scope :user do
    get "register/availability", to: "users/registrations#availability", as: :user_registration_availability
  end

  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
  end

  root to: redirect("/login")

  authenticate :admin_user, ->(u) { u.super_admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  namespace :api do
    namespace :v1 do
      resources :seasons, only: [:index, :show]
      resources :events, only: [:index, :show]
      resources :categories, only: [:show]
      resources :rounds, only: [:show]
      resources :athletes, only: [:index, :show]
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end

# == Route Map
#
# Routes for application:
#                            Prefix Verb   URI Pattern                                                                                       Controller#Action
#                          api_docs GET    /api-docs(.:format)                                                                               redirect(301, /scalar.html)
#                         rswag_api        /api-docs                                                                                         Rswag::Api::Engine
#            new_admin_user_session GET    /admin/login(.:format)                                                                            active_admin/devise/sessions#new
#                admin_user_session POST   /admin/login(.:format)                                                                            active_admin/devise/sessions#create
#        destroy_admin_user_session DELETE /admin/logout(.:format)                                                                           active_admin/devise/sessions#destroy
#           new_admin_user_password GET    /admin/password/new(.:format)                                                                     active_admin/devise/passwords#new
#          edit_admin_user_password GET    /admin/password/edit(.:format)                                                                    active_admin/devise/passwords#edit
#               admin_user_password PATCH  /admin/password(.:format)                                                                         active_admin/devise/passwords#update
#                                   PUT    /admin/password(.:format)                                                                         active_admin/devise/passwords#update
#                                   POST   /admin/password(.:format)                                                                         active_admin/devise/passwords#create
#    cancel_admin_user_registration GET    /admin/cancel(.:format)                                                                           active_admin/devise/registrations#cancel
#       new_admin_user_registration GET    /admin/sign_up(.:format)                                                                          active_admin/devise/registrations#new
#      edit_admin_user_registration GET    /admin/edit(.:format)                                                                             active_admin/devise/registrations#edit
#           admin_user_registration PATCH  /admin(.:format)                                                                                  active_admin/devise/registrations#update
#                                   PUT    /admin(.:format)                                                                                  active_admin/devise/registrations#update
#                                   DELETE /admin(.:format)                                                                                  active_admin/devise/registrations#destroy
#                                   POST   /admin(.:format)                                                                                  active_admin/devise/registrations#create
#                        admin_root GET    /admin(.:format)                                                                                  admin/dashboard#index
#    batch_action_admin_admin_users POST   /admin/admin_users/batch_action(.:format)                                                         admin/admin_users#batch_action
#                 admin_admin_users GET    /admin/admin_users(.:format)                                                                      admin/admin_users#index
#                                   POST   /admin/admin_users(.:format)                                                                      admin/admin_users#create
#              new_admin_admin_user GET    /admin/admin_users/new(.:format)                                                                  admin/admin_users#new
#             edit_admin_admin_user GET    /admin/admin_users/:id/edit(.:format)                                                             admin/admin_users#edit
#                  admin_admin_user GET    /admin/admin_users/:id(.:format)                                                                  admin/admin_users#show
#                                   PATCH  /admin/admin_users/:id(.:format)                                                                  admin/admin_users#update
#                                   PUT    /admin/admin_users/:id(.:format)                                                                  admin/admin_users#update
#                                   DELETE /admin/admin_users/:id(.:format)                                                                  admin/admin_users#destroy
#       batch_action_admin_athletes POST   /admin/athletes/batch_action(.:format)                                                            admin/athletes#batch_action
#                    admin_athletes GET    /admin/athletes(.:format)                                                                         admin/athletes#index
#                                   POST   /admin/athletes(.:format)                                                                         admin/athletes#create
#                 new_admin_athlete GET    /admin/athletes/new(.:format)                                                                     admin/athletes#new
#                edit_admin_athlete GET    /admin/athletes/:id/edit(.:format)                                                                admin/athletes#edit
#                     admin_athlete GET    /admin/athletes/:id(.:format)                                                                     admin/athletes#show
#                                   PATCH  /admin/athletes/:id(.:format)                                                                     admin/athletes#update
#                                   PUT    /admin/athletes/:id(.:format)                                                                     admin/athletes#update
#                                   DELETE /admin/athletes/:id(.:format)                                                                     admin/athletes#destroy
#     batch_action_admin_categories POST   /admin/categories/batch_action(.:format)                                                          admin/categories#batch_action
#                  admin_categories GET    /admin/categories(.:format)                                                                       admin/categories#index
#                                   POST   /admin/categories(.:format)                                                                       admin/categories#create
#                new_admin_category GET    /admin/categories/new(.:format)                                                                   admin/categories#new
#               edit_admin_category GET    /admin/categories/:id/edit(.:format)                                                              admin/categories#edit
#                    admin_category GET    /admin/categories/:id(.:format)                                                                   admin/categories#show
#                                   PATCH  /admin/categories/:id(.:format)                                                                   admin/categories#update
#                                   PUT    /admin/categories/:id(.:format)                                                                   admin/categories#update
#                                   DELETE /admin/categories/:id(.:format)                                                                   admin/categories#destroy
#                   admin_dashboard GET    /admin/dashboard(.:format)                                                                        admin/dashboard#index
#         batch_action_admin_events POST   /admin/events/batch_action(.:format)                                                              admin/events#batch_action
#                      admin_events GET    /admin/events(.:format)                                                                           admin/events#index
#                                   POST   /admin/events(.:format)                                                                           admin/events#create
#                   new_admin_event GET    /admin/events/new(.:format)                                                                       admin/events#new
#                  edit_admin_event GET    /admin/events/:id/edit(.:format)                                                                  admin/events#edit
#                       admin_event GET    /admin/events/:id(.:format)                                                                       admin/events#show
#                                   PATCH  /admin/events/:id(.:format)                                                                       admin/events#update
#                                   PUT    /admin/events/:id(.:format)                                                                       admin/events#update
#                                   DELETE /admin/events/:id(.:format)                                                                       admin/events#destroy
#  batch_action_admin_round_results POST   /admin/round_results/batch_action(.:format)                                                       admin/round_results#batch_action
#               admin_round_results GET    /admin/round_results(.:format)                                                                    admin/round_results#index
#                                   POST   /admin/round_results(.:format)                                                                    admin/round_results#create
#            new_admin_round_result GET    /admin/round_results/new(.:format)                                                                admin/round_results#new
#           edit_admin_round_result GET    /admin/round_results/:id/edit(.:format)                                                           admin/round_results#edit
#                admin_round_result GET    /admin/round_results/:id(.:format)                                                                admin/round_results#show
#                                   PATCH  /admin/round_results/:id(.:format)                                                                admin/round_results#update
#                                   PUT    /admin/round_results/:id(.:format)                                                                admin/round_results#update
#                                   DELETE /admin/round_results/:id(.:format)                                                                admin/round_results#destroy
#         batch_action_admin_rounds POST   /admin/rounds/batch_action(.:format)                                                              admin/rounds#batch_action
#                      admin_rounds GET    /admin/rounds(.:format)                                                                           admin/rounds#index
#                                   POST   /admin/rounds(.:format)                                                                           admin/rounds#create
#                   new_admin_round GET    /admin/rounds/new(.:format)                                                                       admin/rounds#new
#                  edit_admin_round GET    /admin/rounds/:id/edit(.:format)                                                                  admin/rounds#edit
#                       admin_round GET    /admin/rounds/:id(.:format)                                                                       admin/rounds#show
#                                   PATCH  /admin/rounds/:id(.:format)                                                                       admin/rounds#update
#                                   PUT    /admin/rounds/:id(.:format)                                                                       admin/rounds#update
#                                   DELETE /admin/rounds/:id(.:format)                                                                       admin/rounds#destroy
#        batch_action_admin_seasons POST   /admin/seasons/batch_action(.:format)                                                             admin/seasons#batch_action
#                     admin_seasons GET    /admin/seasons(.:format)                                                                          admin/seasons#index
#                                   POST   /admin/seasons(.:format)                                                                          admin/seasons#create
#                  new_admin_season GET    /admin/seasons/new(.:format)                                                                      admin/seasons#new
#                 edit_admin_season GET    /admin/seasons/:id/edit(.:format)                                                                 admin/seasons#edit
#                      admin_season GET    /admin/seasons/:id(.:format)                                                                      admin/seasons#show
#                                   PATCH  /admin/seasons/:id(.:format)                                                                      admin/seasons#update
#                                   PUT    /admin/seasons/:id(.:format)                                                                      admin/seasons#update
#                                   DELETE /admin/seasons/:id(.:format)                                                                      admin/seasons#destroy
#                    admin_comments GET    /admin/comments(.:format)                                                                         admin/comments#index
#                                   POST   /admin/comments(.:format)                                                                         admin/comments#create
#                     admin_comment GET    /admin/comments/:id(.:format)                                                                     admin/comments#show
#                                   DELETE /admin/comments/:id(.:format)                                                                     admin/comments#destroy
#              new_user_session GET    /login(.:format)                                                                                  users/sessions#new
#                  user_session POST   /login(.:format)                                                                                  users/sessions#create
#          destroy_user_session DELETE /logout(.:format)                                                                                 users/sessions#destroy
#             new_user_password GET    /password/new(.:format)                                                                           users/passwords#new
#            edit_user_password GET    /password/edit(.:format)                                                                          users/passwords#edit
#                 user_password PATCH  /password(.:format)                                                                               users/passwords#update
#                                PUT    /password(.:format)                                                                               users/passwords#update
#                                POST   /password(.:format)                                                                               users/passwords#create
#      cancel_user_registration GET    /cancel(.:format)                                                                                 users/registrations#cancel
#         new_user_registration GET    /register(.:format)                                                                               users/registrations#new
#        edit_user_registration GET    /edit(.:format)                                                                                   users/registrations#edit
#             user_registration PATCH  /                                                                                                 users/registrations#update
#                                PUT    /                                                                                                 users/registrations#update
#                                DELETE /                                                                                                 users/registrations#destroy
#                                POST   /                                                                                                 users/registrations#create
# user_registration_availability GET    /register/availability(.:format)                                                                  users/registrations#availability
#            authenticated_root GET    /                                                                                                 dashboard#index
#                          root GET    /                                                                                                 redirect(301, /login)
#                       sidekiq_web        /sidekiq                                                                                          Sidekiq::Web
#                    api_v1_seasons GET    /api/v1/seasons(.:format)                                                                         api/v1/seasons#index
#                     api_v1_season GET    /api/v1/seasons/:id(.:format)                                                                     api/v1/seasons#show
#                     api_v1_events GET    /api/v1/events(.:format)                                                                          api/v1/events#index
#                      api_v1_event GET    /api/v1/events/:id(.:format)                                                                      api/v1/events#show
#                   api_v1_category GET    /api/v1/categories/:id(.:format)                                                                  api/v1/categories#show
#                      api_v1_round GET    /api/v1/rounds/:id(.:format)                                                                      api/v1/rounds#show
#                   api_v1_athletes GET    /api/v1/athletes(.:format)                                                                        api/v1/athletes#index
#                    api_v1_athlete GET    /api/v1/athletes/:id(.:format)                                                                    api/v1/athletes#show
#                rails_health_check GET    /up(.:format)                                                                                     rails/health#show
#  turbo_recede_historical_location GET    /recede_historical_location(.:format)                                                             turbo/native/navigation#recede
#  turbo_resume_historical_location GET    /resume_historical_location(.:format)                                                             turbo/native/navigation#resume
# turbo_refresh_historical_location GET    /refresh_historical_location(.:format)                                                            turbo/native/navigation#refresh
#                rails_service_blob GET    /rails/active_storage/blobs/redirect/:signed_id/*filename(.:format)                               active_storage/blobs/redirect#show
#          rails_service_blob_proxy GET    /rails/active_storage/blobs/proxy/:signed_id/*filename(.:format)                                  active_storage/blobs/proxy#show
#                                   GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                                        active_storage/blobs/redirect#show
#         rails_blob_representation GET    /rails/active_storage/representations/redirect/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations/redirect#show
#   rails_blob_representation_proxy GET    /rails/active_storage/representations/proxy/:signed_blob_id/:variation_key/*filename(.:format)    active_storage/representations/proxy#show
#                                   GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format)          active_storage/representations/redirect#show
#                rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                                       active_storage/disk#show
#         update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                               active_storage/disk#update
#              rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                                    active_storage/direct_uploads#create
#
# Routes for Rswag::Api::Engine:
# No routes defined.
