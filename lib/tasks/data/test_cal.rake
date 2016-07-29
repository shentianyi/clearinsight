namespace :data do
  desc 'build data to check calculate is correct?'
  task :test_cal => :environment do

    Project.where(name: '核对算法正确性').each do |project|
      project.destroy
    end


    Project.transaction do
      user=User.first
      tenant=user.tenant

      project=Project.new(name: '核对算法正确性')
      project.user=user
      project.tenant=tenant

      project.save

      project_item=project.project_items.first

      Kpi::Capacity.first.setting(project_item).setting_items.where(field_name: 'theoretic_time').update(field_value: 3600)
      Kpi::Capacity.first.setting(project_item).targets.where(code: 'CUSTOM_DEFINE').update(value: 17.5)
      Kpi::EOne.first.setting(project_item).setting_items.where(field_name: 'standard_time').update(field_value: 18709.8)


      node_set=project_item.node_set
      work_unit=%w(总装1-1 总装1-2 总装1-3 总装1-4 总装1-7 总装2-2 总装2-4 总装2-5 总装2-6 总装2-7 总装2-8 总装3-1 总装3-4 总装3-5 总装3-6 总装3-7 总装3-8 总装3-9 总装4-1 总装4-4 总装4-7 总装4-8 总装4-9 总装5-1 总装5-2 总装5-3 总装5-4 总装5-5 总装5-6 总装5-7 总装5-8 总装5-9 总装5-10 总装6-1 总装6-2 总装6-4 总装6-6 总装6-7 总装7-2 总装7-3 总装7-4 总装7-7 总装8-1 总装8-2 总装8-3 总装8-4 总装8-5 总装8-6 总装8-7 总装8-8 支架1-1 支架1-2 电测 保险丝安装 打螺母+照相 检验 打包)
      hc=%w(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 4 1 1 4 1)
      nodes=[]
      work_unit.each_with_index do |unit, i|
        w= node_set.nodes.build(name: unit, type: NodeType::WORK_UNIT, tenant_id: tenant.id, is_selected: false)
        w.save
        if hc[i].to_i>0
          for ii in 0...hc[i].to_i
            w.children.create(name: unit+'_worker_'+(ii+1).to_s, type: NodeType::WORKER, node_set_id: node_set.id, tenant_id: tenant.id, is_selected: false)
          end
        end
        nodes<<w
      end


      ct=Kpi::CycleTime.first

      data=%w(总装1-1 181 155 168 161 175 总装1-2 168 173 170 165 175 总装1-3 199 195 189 197 199 总装1-4 165 155 150 156 154 总装1-7 155 150 157 153 161 总装2-2 207 211 207 210 207 总装2-4 146 155 160 140 151 总装2-5 192 191 195 197 189 总装2-6 185 191 189 190 194 总装2-7 196 197 188 195 200 总装2-8 183 177 180 178 184 总装3-1 201 203 190 199 194 总装3-4 191 162 176 170 182 总装3-5 191 165 178 173 183 总装3-6 196 188 193 200 200 总装3-7 187 200 197 191 191 总装3-8 166 193 179 173 185 总装3-9 198 191 193 190 200 总装4-1 160 167 172 170 165 总装4-4 170 194 179 191 172 总装4-7 179 172 181 175 176 总装4-8 191 192 200 194 185 总装4-9 196 197 183 200 189 总装5-1 172 160 173 165 168 总装5-2 213 191 192 191 200 总装5-3 190 182 179 186 188 总装5-4 130 132 140 129 136 总装5-5 178 181 185 175 173 总装5-6 170 167 165 159 169 总装5-7 178 187 173 181 186 总装5-8 193 172 184 191 185 总装5-9 201 189 194 189 200 总装5-10 170 184 181 176 177 总装6-1 170 165 164 160 174 总装6-2 190 191 170 200 188 总装6-4 166 169 171 166 176 总装6-6 131 146 140 137 140 总装6-7 185 186 185 179 191 总装7-2 194 200 195 190 191 总装7-3 191 194 200 194 195 总装7-4 140 140 143 135 138 总装7-7 170 181 179 176 180 总装8-1 144 153 156 141 139 总装8-2 160 168 167 159 158 总装8-3 158 152 159 149 150 总装8-4 169 160 158 161 149 总装8-5 140 144 139 142 145 总装8-6 175 181 185 179 180 总装8-7 170 167 159 174 165 总装8-8 197 198 189 195 190 支架1-1 145 150 141 149 147 支架1-2 146 142 138 141 143 电测 130 150 140 190 161 保险丝安装 122 128 130 126 129 打螺母+照相 155 130 170 152 165 检验 155 153 164 160 157 打包 145 146 145 144 147)
      data.each_slice(6) do |arr|
        node=Node.where(name: arr[0], node_set_id: node_set.id).first
        for i in 1...6
          Kpi::Entry.create(kpi_id: ct.id,
                            node_id: node.id,
                            project_item_id: project_item.id,
                            tenant_id: tenant.id,
                            entry_at: Time.now,
                            value: arr[i].to_f)
        end
      end


    end
  end
end