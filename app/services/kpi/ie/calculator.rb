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
        data2=calculate_all(project_item.source_project_item) if project_item.source_project_item
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
              xAxis: data2.nil? ? "优化前#{data1[key][:kpi].name}" : "优化后#{data1[key][:kpi].name}",
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

        max_unit_cycle_time=nil #((max_entry=Kpi::Entry.where(project_item_id: project_item.id, kpi_id: cycle_time.id).order(value: :desc).first).nil? ? 1 : max_entry.value) # 最大单位生产工时

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

       
        map=%Q{
           function(){ 
                  emit(this.node_id,parseFloat(this.value.toString()));
              };
        }
        reduce=%Q{
           function(key,values){
 return Array.avg(values);
};
        }


		map1=%Q{
		 function(){
		     var v={count:1,value:this.value,avg:0,min:this.value,max:this.value};
			 emit(this.node_id,v);
	    	};
		}


		reduce1=%Q{
		  function(key,values){
			var result={count:0,value:0,avg:0,min:null,max:null};
			   for(var i=0;i<values.length;i++){
			     result.count+=values[i].count;
				 result.value+=values[i].value;
				 if(result.max==null){result.max=values[i].max;}
				 if(result.min==null){result.min=values[i].min;}
				 if(result.max<values[i].max){result.max=values[i].max;}
				  if(result.min>values[i].min){result.min=values[i].min;}
		 };
		 return result;
		}
		}
     finalize=%Q{
		            function(key, reducedVal){
					if(reducedVal.count==1){
			       	reducedVal.max=reducedVal.min=reducedVal.avg= reducedVal.value;
					}else if(reducedVal.count>1){
					   reducedVal.avg=reducedVal.value/reducedVal.count;
					   }else{
					    reducedVal.value=reducedVal.max=reducedVal.min=reducedVal.avg=0;
						}
						                       return reducedVal;
											                 };
	 }


        hc_time_sum=0
q= Kpi::Entry.where(project_item_id: project_item.id, kpi_id: cycle_time.id)

        ct_data=   q.map_reduce(map1, reduce1).finalize(finalize).out(inline: true)

        p '--------------------'
        ct_data.each do |d|
          p d
          puts d['_id'].to_json
p 
        end

        p '--------------------'

        work_units.each do |unit|
          x=unit.name
          avg_y=min_y=takt_y=0
          if d=ct_data.select { |dd| dd['_id'].to_i==unit.id }.first
            avg_y=d['value']['avg'].round(cycle_time.round)
            min_y=d['value']['min'].round(cycle_time.round)

# avg_y=d['value'].round(cycle_time.round)
 #           min_y=0
#if entry=q.where(node_id:unit.id).sort(value: :asc).first
#min_y=entry.value#d['value']['min'].round(cycle_time.round)
#end

            if max_unit_cycle_time.nil?
              max_unit_cycle_time=avg_y
            end

            if max_unit_cycle_time<avg_y
              max_unit_cycle_time=avg_y
            end
            hc_time_sum+=avg_y*unit.children.where(type: NodeType::WORKER).count
          end
          takt_y=takt
          data[:CYCLE_TIME][:lines][:AVG]<<{
              xAxis: x,
              yAxis: avg_y,
              node: {
                  id:unit.id
              }
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


        

        max_unit_cycle_time=1 if max_unit_cycle_time==0 || max_unit_cycle_time==nil


        # 计算Capacity
        data[:CAPACITY]={
            value: theoretic_time/max_unit_cycle_time,
            unit_string: ca_setting.unit_string,
            targets: ca_setting.targets, kpi: capacity}
        # 计算HumanCapacity
        data[:HUMAN_CAPACITY]={value: hc_count, unit_string: hc_setting.unit_string, targets: hc_setting.targets, kpi: hc}
        # 计算E1
        data[:E1]={value: (standard_time*100)/(max_unit_cycle_time*hc_count), unit_string: e1_setting.unit_string, targets: e1_setting.targets, kpi: e1}
p '**********************'
        p max_unit_cycle_time
p  standard_time
p max_unit_cycle_time*hc_count
        p '**********************'
        
# 计算LOB
        data[:LOB]={value: (hc_time_sum*100)/hc_count/max_unit_cycle_time, unit_string: lob_setting.unit_string, targets: lob_setting.targets, kpi: lob}
        
p '^^^^^^^^^^^^^^^^^^^^^^^^^^'
p hc_time_sum
p hc_count
p max_unit_cycle_time
p hc_time_sum/hc_count/max_unit_cycle_time
p '^^^^^^^^^^^^^^^^^^^^^^^^^^'

# ct_data
        data

      end


      def cycle_time_detail project_item, node_id
        return [] if project_item.nil?
        # nodes=project_item.nodes.where(type: NodeType::WORKER).all.collect{|n| [n.id,n.name]}.to_h
        ct=Kpi::CycleTime.first.id
        data=[]
        Kpi::Entry.where(kpi_id: Kpi::CycleTime.first.id, node_id: node_id, project_item_id: project_item.id).order(entry_at: :asc).each do |d|
          data<<{
              xAxis: d.entry_at.localtime.strftime('%Y-%m-%d %H:%M:%S'),
              yAxis: d.value.round(ct.round)
          }
        end
        data
      end
    end
  end
end
