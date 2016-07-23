module Api
  module V1
    class ProjectsController < Api::V1::ApplicationController
      # before_action :doorkeeper_authorize!

      def index
        if user = User.find_by_id(params["user_id"])

        else

        end


        # login_info=JSON.parse(params)
        # raise 'wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww'
      end

    end
  end
end