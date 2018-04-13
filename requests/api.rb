require_relative '../models/user'

class Api < Grape::API
  version 'v1', using: :path
  format :json
  prefix :api

  desc 'Get all users from account'
  params do
    requires :account_id, type: String, desc: 'Account ID'
  end
  namespace :instructure do
    resource :accounts do
      get '/:account_id/users' do
        users = User.find_by_account(params[:account_id])
        error!('Account not found', 404) if users.empty?
        users
      end
    end
  end
end
