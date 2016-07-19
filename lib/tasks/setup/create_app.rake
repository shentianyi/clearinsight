namespace :setup do
  desc 'Create Default App'
  task :create_app=>:environment do
    # init first system user
    unless user=User.find_by_email('admin@ci1.com')
      user=User.create({name: 'admin1', password: '123456@', password_confirmation: '123456@', role: 100, email: 'admin@ci1.com'})
    end

    # init oauth app
    unless Settings.default_app
      app=Doorkeeper::Application.new(name: Settings.oauth.application.name,
                                      uid: Settings.oauth.application.uid,
                                      redirect_uri: Settings.oauth.application.redirect_uri)
      app.owner = user
      app.save
    end

    # init first system user access token
    user.generate_access_token

    puts 'Default App Create Succ'
  end
end