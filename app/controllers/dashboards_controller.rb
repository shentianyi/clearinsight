class DashboardsController < ApplicationController

  def ie
    render json: Kpi::Ie::Calculator.new.cal_all(params[:id])
  end
end
