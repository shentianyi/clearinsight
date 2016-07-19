namespace :setup do
  desc 'set up all data one by one'
  task :init => :environment do
    puts '====== 1.create default tenant'
    Rake::Task['setup:create_tenant'].invoke

    puts '====== 1.2 create default app'
    Rake::Task['setup:create_app'].invoke

    puts '====== 2.create system kpi'
    Rake::Task['setup:create_kpi'].invoke
  end
end