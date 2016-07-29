namespace :test do
  desc 'build some test data for fun...'
  task :test_cal => :environment do

    Project.transcation do
      user=User.first
      tenant=user.tenant

      project=Project.new(name: '核对算法正确性')
      project.user=user
      project.tenant=tenant

      project.save

      project_item=project.project_items.first

     s= '总装1-1 总装1-2 总装1-3 总装1-4 总装1-7 总装2-2 总装2-4 总装2-5 总装2-6 总装2-7 总装2-8 总装3-1 总装3-4 总装3-5 总装3-6 总装3-7 总装3-8 总装3-9 总装4-1 总装4-4 总装4-7 总装4-8 总装4-9 总装5-1 总装5-2 总装5-3 总装5-4 总装5-5 总装5-6 总装5-7 总装5-8 总装5-9 总装5-10 总装6-1 总装6-2 总装6-4 总装6-6 总装6-7 总装7-2 总装7-3 总装7-4 总装7-7 总装8-1 总装8-2 总装8-3 总装8-4 总装8-5 总装8-6 总装8-7 总装8-8 支架1-1 支架1-2 电测 保险丝安装 打螺母+照相 检验 打包'
    end
  end
end