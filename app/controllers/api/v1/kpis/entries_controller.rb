module Api
  module V1
    module Kpis
      class EntriesController < Api::V1::ApplicationController
        guard_all!

        def index
          render json: '111111112'
        end

        def create
          if entry = Kpi::EntryService.create(JSON.parse(params["entry"]).symbolize_keys)
          # if entry = Kpi::EntryService.create(params)
            render json: {result: true, data: entry}
          else
            render json: {result: false, data: ''}
          end
        end


      end
    end
  end
end