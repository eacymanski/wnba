# frozen_string_literal: true

Rails.application.routes.draw do
  resources :drafts, only: %i[index show]
  root 'drafts#show'
end
