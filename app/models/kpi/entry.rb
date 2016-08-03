module Kpi
  class Entry
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Attributes::Dynamic

    store_in collection: 'kpi_entries'

    # belongs_to :setting, class_name: 'Kpi::Setting'


    field :kpi_id, type: Integer
    field :project_item_id, type: Integer
    field :tenant_id, type: Integer
    field :node_id, type: Integer
    field :node_code, type: String
    field :node_uuid, type: String
    # field :value, type: BigDecimal
    field :value,type:Float
    field :entry_at, type: DateTime


    def project_item
      if (project_item = ProjectItem.find_by_id(self.project_item_id)).nil?
        nil
      else
        project_item
      end
    end

    def node
      if (node = Node.find_by_id(self.node_id)).nil?
        nil
      else
        node
      end
    end

    def entry_at_display
      self.entry_at.localtime.strftime('%H:%M:%S')
    end

    def self.generated_details_data kpi, project_item
      kpi_entries = []
      return kpi_entries if kpi.blank? || project_item.blank?

      kpi_entries=Kpi::Entry.where(kpi_id: kpi.id, project_item_id: project_item.id)
      kpi_entries
    end

    def self.to_total_xlsx kpi_entries, kpi
      p = Axlsx::Package.new
      wb = p.workbook
      wb.add_worksheet(:name => "sheet1") do |sheet|
        sheet.add_row ["序号", "项目编号", "轮次名称", "节点", "签到时间", "签退时间", "工时"]
        if kpi
          kpi_entries.each_with_index { |kpi_entry, index|
            sheet.add_row [
                              index+1,
                              kpi_entry.project_item.blank? ? '' : kpi_entry.project_item.project.name,
                              kpi_entry.project_item.blank? ? '' : kpi_entry.project_item.name,
                              kpi_entry.node.blank? ? '' : kpi_entry.node.name,
                              (kpi_entry.entry_at.to_time - kpi_entry.value).localtime.strftime('%Y-%m-%d %H:%M:%S'),
                              kpi_entry.entry_at.localtime.strftime('%Y-%m-%d %H:%M:%S'),
                              kpi_entry.value
                          ]
          }
        end
      end
      p.to_stream.read
    end

  end
end