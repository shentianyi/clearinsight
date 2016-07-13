namespace :tenant do
  desc "Create Tenant And Super User"
  task :create, [:name] => :environment do |t, args|
    # puts '-----------start--------------'
    unless Tenant.find_by_name(args[:name])
      super_user=User.new(:name => args[:name], :email => "#{args[:name]}@ci.com", :role => 100, :is_system => true, :password => "123456@")
      tenant=Tenant.new(:name => args[:name])
      super_user.tenant=tenant
      tenant.super_user=super_user
      tenant.save
      puts '-----------succ--------------'
    else
      puts '租户已存在'
    end
  end
end





