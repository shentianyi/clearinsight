module Kpi
  module Ie
    class Calculator

      def cal_all(project_item_id)
        project_item=ProjectItem.find_by_id(project_item_id)

        data={
            CYCLE_TIME: {
                unit_string: 'S',
                lines: {
                    AVG: [],
                    MIN: [],
                    TAKT: []
                }
            },
            CAPACITY: {
                unit_string: 'pcs/H',
                lines: {
                    CAPACITY: []
                }
            },
            HUMAN_CAPACITY: {
                unit_string: '人',
                lines: {
                    HUMAN_CAPACITY: []
                }
            },
            E1: {
                unit_string: '%',
                lines: {
                    E1: []
                }
            },
            LOB: {
                unit_string: '%',
                lines: {
                    LOB: []
                }
            }
        }


        data[:CYCLE_TIME][:lines].each do |k, v|
          for i in 0...30
            v<<{
                xAxis: "WS_#{i}",
                yAxis: rand(50)
            }
          end
        end

        data[:CAPACITY][:lines].each do |k, v|
          v<<{
              xAxis: '客户需求',
              yAxis: rand(50)
          }
          v<<{
              xAxis: '优化前产能',
              yAxis: rand(40)
          }
          v<<{
              xAxis: '优化后产能',
              yAxis: rand(60)
          }
        end

        data[:HUMAN_CAPACITY][:lines].each do |k, v|

          v<<{
              xAxis: '优化前人力',
              yAxis: rand(40)
          }
          v<<{
              xAxis: '优化后人力',
              yAxis: rand(60)
          }
        end

        data[:E1][:lines].each do |k, v|

          v<<{
              xAxis: '优化前E1',
              yAxis: rand(40)
          }
          v<<{
              xAxis: '优化后E1',
              yAxis: rand(60)
          }
        end

        data[:LOB][:lines].each do |k, v|

          v<<{
              xAxis: '优化前平衡率',
              yAxis: rand(40)
          }
          v<<{
              xAxis: '优化后平衡率',
              yAxis: rand(60)
          }
        end


        data
      end


      def calculate_all_and_compare(project_item)
        data={}
        data1=calculate_all(project_item)
        data2=calculate_all(project_item.source_project_item)
        data[:CYCLE_TIME]=data1[:CYCLE_TIME]
        [:CAPACITY, :HUMAN_CAPACITY, :E1, :LOB].each do |key|
          data[key]={
              unit_string: data1[key][:unit_string],
              lines: {

              }
          }
          data[key][:lines][key]=[]

          data1[key][:targets].each do |t|
            data[key][:lines][key]<<{
                xAxis: t.name,
                yAxis: t.value.round(data1[:CAPACITY][:kpi].round),
            }
          end
          if data2
            data[key][:lines][key]<<{
                xAxis: "优化前#{data1[key][:kpi].name}",
                yAxis: data2[key][:value].round(data1[key][:kpi].round),
            }
          end

          data[key][:lines][key]<<{
              xAxis: "优化后#{data1[key][:kpi].name}",
              yAxis: data1[key][:value].round(data1[key][:kpi].round),
          }
        end

        data
      end

      def calculate_all_single(project_item)
        data={}
        data1=calculate_all(project_item)
        # data[:CYCLE_TIME]=data1[:CYCLE_TIME]
        [:CAPACITY, :HUMAN_CAPACITY, :E1, :LOB].each do |key|
          data[key]={
              unit_string: data1[key][:unit_string],
              lines: {

              }
          }
          data[key][:lines][key]=[]

          data[key][:lines][key]<<{
              xAxis: "#{project_item.name}",
              yAxis: data1[key][:value].round(data1[key][:kpi].round),
          }
        end

        data
      end

      def calculate_all(project_item)
        return nil if project_item.nil?
        data={
            CYCLE_TIME: {
                unit_string: '',
                lines: {
                    AVG: [],
                    MIN: [],
                    TAKT: []
                }
            },
            CAPACITY: 0,
            HUMAN_CAPACITY: 0,
            E1: 0,
            LOB: 0
        }
        work_units=project_item.nodes.where(type: NodeType::WORK_UNIT).all
        # 基本计算因子
        # cycletime
        cycle_time=Kpi::CycleTime.first
        ct_setting=cycle_time.setting(project_item)
        # capacity
        capacity=Kpi::Capacity.first
        ca_setting=capacity.setting(project_item)
        # hc
        hc=Kpi::HumanCapacity.first
        hc_setting=hc.setting(project_item)
        # e1
        e1=Kpi::EOne.first
        e1_setting=e1.setting(project_item)
        # lob
        lob=Kpi::Lob.first
        lob_setting=lob.setting(project_item)

        max_unit_cycle_time=((max_entry=Kpi::Entry.where(project_item_id: project_item.id, kpi_id: cycle_time.id).order(value: :desc).first).nil? ? 1 : max_entry.value) # 最大单位生产工时
        max_unit_cycle_time=1 if max_unit_cycle_time==0
        hc_count=project_item.nodes.where(type: NodeType::WORKER).count # 人力
        hc_count=1 if hc_count==0
        theoretic_time=ca_setting.setting_theoretic_time # 产能理论工时
        theoretic_time=1 if theoretic_time.nil? || theoretic_time==0
        custom_define_capacity=ca_setting.target_custom_define # 客户需求产能
        custom_define_capacity=1 if custom_define_capacity.nil? || custom_define_capacity==0
        custom_define_capacity=custom_define_capacity.round(capacity.round)
        takt= (theoretic_time/custom_define_capacity).round(cycle_time.round) # 客户需求生产周期, custom define cycle time
        standard_time=e1_setting.setting_standard_time # E1标准工时

        # 计算CycleTime
        #begin
        data[:CYCLE_TIME][:unit_string]= ct_setting.unit_string

        q= Kpi::Entry.where(project_item_id: project_item.id, kpi_id: cycle_time.id)
        map=%Q{
           function(){
                  var v={count:1,value:parseFloat(this.value)};
                  emit(this.node_id,v);
              };
        }
        reduce=%Q{
           function(key,values){
            var result={count:0,total:0,avg:0,max:0,min:0};
            for(var i=0;i<values.length;i++){
               result.count+=values[i].count;
               if(values[i].value!=null){
               result.total+=values[i].value;
              }
               if(result.max<values[i].value){result.max=values[i].value;}
               if(result.min>values[i].value){result.min=values[i].value;}
            }
            return result;};
        }
        finalize=%Q{
           function(key, reducedVal){
   reducedVal.avg=reducedVal.total/reducedVal.count;
                       return reducedVal;
              };
        }

        hc_time_sum=0
        ct_data= q.map_reduce(map, reduce).out(inline: true).finalize(finalize)
        work_units.each do |unit|
          x=unit.name
          avg_y=min_y=takt_y=0

          if d=ct_data.select { |dd| dd['_id']==unit.id }.first
            avg_y=d['value']['avg'].round(cycle_time.round)
            min_y=d['value']['min'].round(cycle_time.round)
            takt_y=takt
            hc_time_sum+=avg_y*unit.children.where(type: NodeType::WORKER).count
          end
          data[:CYCLE_TIME][:lines][:AVG]<<{
              xAxis: x,
              yAxis: avg_y
          }
          data[:CYCLE_TIME][:lines][:MIN]<<{
              xAxis: x,
              yAxis: min_y
          }
          data[:CYCLE_TIME][:lines][:TAKT]<<{
              xAxis: x,
              yAxis: takt_y
          }
        end
        # end

        # 计算Capacity
        data[:CAPACITY]={
            value: theoretic_time/max_unit_cycle_time,
            unit_string: ca_setting.unit_string,
            targets: ca_setting.targets, kpi: capacity}
        # 计算HumanCapacity
        data[:HUMAN_CAPACITY]={value: hc_count, unit_string: hc_setting.unit_string, targets: hc_setting.targets, kpi: hc}
        # 计算E1
        data[:E1]={value: standard_time/(max_unit_cycle_time*hc_count)*100, unit_string: e1_setting.unit_string, targets: e1_setting.targets, kpi: e1}
        # 计算LOB
        data[:LOB]={value: hc_time_sum/hc_count/max_unit_cycle_time*100, unit_string: lob_setting.unit_string, targets: lob_setting.targets, kpi: lob}
        # ct_data
        data

      end

    end
  end
end