module Api
  module V1
    class NodesController < Api::V1::ApplicationController
      guard_all!

      def bind_devise
        if node=Node.find_by_id(params[:id])
          if node.update(devise_code: params[:devise_code])
           render json: {result: true}
          else
            render json:  {result: false,
             content: node.errors.full_message}
          end
        else
          render json:  {
              result: false,
              content: '工位不存在'
                 }
        end
      end
    end
  end
end