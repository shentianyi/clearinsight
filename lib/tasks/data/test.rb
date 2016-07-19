namespace :data do
  desc 'build some test data for fun...'
  task :test => :environment do
    Node.all.each do |node|

    end
  end
end