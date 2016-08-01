class Tenant < ApplicationRecord
  has_many :users
  belongs_to :super_user, :class_name => 'User', :foreign_key => 'user_id'
  has_many :projects


  def self.create_with_user params
    Tenant.transaction do
      super_user=User.new(name: params[:user][:name], email: params[:user][:email], role: Role.admin, is_system: true, password: params[:user][:password])
      tenant=Tenant.new(name: params[:tenant][:name])
      super_user.tenant=tenant
      tenant.super_user=super_user
      tenant.save
      tenant
    end
  end
end
