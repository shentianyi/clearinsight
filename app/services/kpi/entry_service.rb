module Kpi
  class EntryService

    def self.create params
      entry=Kpi::Entry.new(kpi_id: params[:kpi_id], project_item_id: params[:project_item_id], tenant_id: params[:tenant_id],
                           node_id: params[:node_id], node_code: params[:node_code], node_uuid: params[:node_uuid], value: params[:value], entry: params[:entry])
      return entry if entry.save
    end

    def self.validate_params params
      msg=Message.new(contents: [])

      unless kpi=Kpi.find_by_id(params[:kpi_id])
        msg.contents<<"KPI: #{params[:kpi_id]}不存在"
      end

      unless p_i=ProjectItem.find_by_id(params[:project_item_id])
        msg.contents<<"Project Item: #{params[:kpi_id]}不存在"
      end

      unless tenant=Tenant.find_by_id(params[:tenant_id])
        msg.contents<<"Tenant: #{params[:tenant_id]}不存在"
      end

      unless node=Node.find_by_id(params[:node_id])
        msg.contents<<"Node[id]: #{params[:node_id]}不存在"
      end

      unless node=Node.find_by_uuid(params[:node_uuid])
        msg.contents<<"Node[uuid]: #{params[:node_uuid]}不存在"
      end

      unless node=Node.find_by_code(params[:node_code])
        msg.contents<<"Node[code]: #{params[:node_code]}不存在"
      end

      if params[:value].blank?
        msg.contents<<"Value 不能为空"
      end

      if params[:entry].blank?
        msg.contents<<"Entry 不能为空"
      end

      unless msg.result=(msg.contents.size==0)
        msg.content=msg.contents.join('/')
      end

      msg
    end
  end
end