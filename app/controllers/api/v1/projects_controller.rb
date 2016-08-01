module Api
  module V1
    class ProjectsController < Api::V1::ApplicationController
      # before_action :doorkeeper_authorize!
      guard_all!

      def index
        if params["status"].blank?
          projects=current_user.projects.distinct
        else
          projects=current_user.projects.where(status: params["status"]).distinct
        end
        render json: projects
      end

      def work_unit_nodes
        if project=current_user.tenant.projects.find_by_id(params["project_id"])
          nodes=project.project_items.last.nodes.select("nodes.*,diagrams.diagrammable_id as project_item_id").where(type: NodeType::WORK_UNIT)
          render json: nodes
        else
          render json: {result: false}
        end
      end

    end
  end
end