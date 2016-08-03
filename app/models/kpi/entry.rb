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
        sheet.add_row ["序号", "员工号", "项目编号", "签到时间", "签退时间", "工时", "间歇时间"]
        if kpi
          kpi_entries.each_with_index { |kpi_entry, index|
            sheet.add_row [
                              index+1,
                              kpi_entry.kpi_id,
                              kpi_entry.project_item_id,
                              kpi_entry.node_id,
                              kpi_entry.node_code,
                              kpi_entry.node_uuid,
                              kpi_entry.value,
                              kpi_entry.entry_at
                          ]
          }
        end
      end
      p.to_stream.read
    end

  end
end