class DashboardsController < ApplicationController

  def ie
    render json: Kpi::Ie::Calculator.new.calculate_all_and_compare(ProjectItem.find_by_id(params[:id]))
  end

  def ie_single
    render json: Kpi::Ie::Calculator.new.calculate_all_single(ProjectItem.find_by_id(params[:id]))
  end
end
