# frozen_string_literal: true

Rails.application.routes.draw do
  resource :drafts, only: [:show]
  root 'drafts#show'
end
