module Api
  module V1
    module Kpis
      class EntriesController < Api::V1::ApplicationController
        guard_all!

        def index
          render json: '111111112'
        end

        def create
          param_data=JSON.parse(params[:entry]).symbolize_keys
          if(param_data[:kpi_code].present?)
            if kpi=KpiBase.find_by_code(param_data[:kpi_code])
              param_data[:kpi_id]=kpi.id
            end
          end
          if entry = Kpi::EntryService.create(param_data)
          # if entry = Kpi::EntryService.create(params)
            render json: entry.to_json
          else
            render json: {result: false, data: ''}
          end
        end


      end
    end
  end
end