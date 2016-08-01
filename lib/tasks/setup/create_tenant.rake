namespace :setup do
  desc 'Create Tenant And Super User'
  task :create_tenant=>:environment do
    # puts '-----------start--------------'
    unless Tenant.find_by_name('ClearInsight')
      super_user=User.new(:name => 'admin', :email => 'admin@ci.com', :role => 100, :is_system => true, :password => "123456@")
      tenant=Tenant.new(name: 'ClearInsight')
      super_user.tenant=tenant
      tenant.super_user=super_user
      tenant.save
      puts '-----------succ--------------'
    else
      puts '租户已存在'
    end
  end
end