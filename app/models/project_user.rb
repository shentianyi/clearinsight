class ProjectUser < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :tenant


  def self.invite_people params
    msg=Message.new(result: true, object: [], contents: [])

    unless params.blank?
      params.keys.each do |key|
        if user=User.find_by_email(params[key][:email])
          msg.object<<{user_id: user.id, role: params[key][:role]}
        else
          msg.contents << "邮箱:#{params[key][:email]}未注册!"
        end
      end
      unless msg.result=(msg.contents.size==0)
        msg.content=msg.contents.join('/')
      end
    end

    msg
  end
end
