class System


  def self.init
    # init first system user
    unless user=User.find_by_email('admin@ci.com')
      user=User.create({name: 'admin', password: '123456@', password_confirmation: '123456@', role_id: 100, email: 'admin@ci.com'})
    end

    # init oauth app
    unless default_app
      app=Doorkeeper::Application.new(name: Settings.oauth.application.name,
                                      uid: Settings.oauth.application.uid,
                                      redirect_uri: Settings.oauth.application.redirect_uri)
      app.owner = user
      app.save
    end

    # init first system user access token
    user.generate_access_token

  end

  def self.default_app
    Doorkeeper::Application.by_uid(Settings.oauth.application.uid)
  end
end