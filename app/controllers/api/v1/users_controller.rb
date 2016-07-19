module Api
  module V1
    class UsersController < Api::V1::ApplicationController
      # before_action :doorkeeper_authorize!

      def index
        render json: '11111111'
      end

      def login
        # requires! :email, type: String
        # requires! :password, type: String
# p request
        if (user=User.find_for_database_authentication(email: params[:email])) && user.valid_password?(params[:password])
          render json: {
                     id: user.id,
                     email: user.email,
                     name: user.name,
                     token: user.access_token.token
                 }
        else
          render json: { ok: 0 }
        end
      end



    end
  end
end