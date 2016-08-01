module Dashboards
  class IesController < ApplicationController

    def full_compare
      render json: Kpi::Ie::Calculator.new.calculate_all_and_compare(ProjectItem.find_by_id(params[:id]))
    end

    def single
      render json: Kpi::Ie::Calculator.new.calculate_all_single(ProjectItem.find_by_id(params[:id]))
    end

    def cycle_time_detail
      render json: Kpi::Ie::Calculator.new.cycle_time_detail(ProjectItem.find_by_id(params[:id]),params[:node_id])
    end
  end
end
