module Api
  module V1
    module Kpis
      class SettingsController < Api::V1::ApplicationController
        guard_all!

        def index
          render json: '111111112'
        end

        def create
          if setting=Kpi::SettingService.create(params)
            render json: {result: true, data: setting}
          else
            render json: {result: false, data: ''}
          end
        end


      end
    end
  end
end