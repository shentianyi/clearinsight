
kpi = KpiBase.find_by_code('CYCLE_TIME')

ProjectItem.all.each do |pi|
  pi.nodes.where(type: NodeType::WORK_UNIT).each do |node|
    10.times.each do |i|
      Kpi::Entry.create(
          {
              kpi_id: kpi.id,
              project_item_id: pi.id,
              node_code: node.code,
              node_uuid: node.uuid,
              value: rand(10..1000),
              entry_at: "2016-8-1 #{i}:00:00",
              node_id: node.id
          }
      )
    end
  end
end


