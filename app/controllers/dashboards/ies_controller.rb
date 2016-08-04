module Dashboards
  class IesController < ApplicationController

    def full_compare
      @project_item=ProjectItem.find_by_id(params[:id])
      puts @project_item.logs.to_json
      render json: Kpi::Ie::Calculator.new.calculate_all_and_compare(@project_item)
    end

    def single
      render json: Kpi::Ie::Calculator.new.calculate_all_single(ProjectItem.find_by_id(params[:id]))
    end

    def cycle_time_detail
      render json: Kpi::Ie::Calculator.new.cycle_time_detail(ProjectItem.find_by_id(params[:id]),params[:node_id])
    end
  end
end
