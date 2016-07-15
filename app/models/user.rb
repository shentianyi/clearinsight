class User < ApplicationRecord
  extend Devise::Models

  validates_presence_of :name, :message => "请输入完整的用户信息!"
  validates_presence_of :email, :message => "请输入完整的用户信息!"
  # validates_presence_of :role, :message => "请输入完整的用户信息!"
  validates_presence_of :password, :message => "请输入完整的用户信息!"
  validates_uniqueness_of :email, :message => "邮箱已被注册!"
  # validates_length_of :password, :minimum => 6, :message => "密码不可为空,且最小为6位字符"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :tenant
  has_many :project_users, :dependent => :destroy
  acts_as_tenant(:tenant)


  def method_missing(method_name, *args, &block)
    if Role::RoleMethods.include?(method_name)
      Role.send(method_name, self.role)
    elsif method_name.match(/permission?/)
      if self.admin?
        true
      else
        if self.permissions.where(name: args[0].to_s).blank?
          false
        else
          true
        end
      end
    else
      super
    end
  end
end
