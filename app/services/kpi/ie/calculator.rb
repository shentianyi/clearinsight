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

        data[:CAPACITY][:lines].each do |k,v|
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

        data[:HUMAN_CAPACITY][:lines].each do |k,v|

          v<<{
              xAxis: '优化前人力',
              yAxis: rand(40)
          }
          v<<{
              xAxis: '优化后人力',
              yAxis: rand(60)
          }
        end

        data[:E1][:lines].each do |k,v|

          v<<{
              xAxis: '优化前E1',
              yAxis: rand(40)
          }
          v<<{
              xAxis: '优化后E1',
              yAxis: rand(60)
          }
        end

        data[:LOB][:lines].each do |k,v|

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

    end
  end
end