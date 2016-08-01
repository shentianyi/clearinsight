namespace :setup do
  desc 'create system kpi'
  task :create_kpi => :environment do

    kpis=[{
              name: 'CycleTime',
              code: 'CYCLE_TIME',
              description: '生产周期',
              round: 0,
              unit_string: 's',
              is_system: true
          }, {
              name: 'Capacity',
              code: 'CAPACITY',
              description: '产能',
              round: 2,
              unit_string: 'pcs/H',
              is_system: true
          }, {
              name: 'HumanCapacity',
              code: 'HUMAN_CAPACITY',
              description: '人力',
              round: 0,
              unit_string: '人',
              is_system: true
          }, {
              name: 'E1',
              code: 'E1',
              description: 'E1',
              round: 2,
              unit_string: '%',
              is_system: true
          }, {
              name: 'LOB',
              code: 'LOB',
              description: 'LOB',
              round: 2,
              unit_string: '%',
              is_system: true
          }]
    KpiBase.transaction do
      kpis.each_with_index do |kpi, i|
        unless KpiBase.find_by_code(kpi[:code])
          puts "================#{i+1}.create #{kpi[:name]}"
          KpiBase.create(kpi)
        end
      end
    end
  end
end
