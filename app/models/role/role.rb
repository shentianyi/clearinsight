#encoding: utf-8
require 'base_class'
class Role
  RoleMethods=[:admin?, :user]
  @@roles={
      :'100' => {:name => 'admin', :display => (I18n.t 'manage.user.role.admin')},
      :'200' => {:name => 'user', :display => (I18n.t 'manage.user.role.user')}
  }

  class<<self
    RoleMethods.each do |m|
      define_method(m) { |id|
        @@roles[id_sym(id)][:name]==m.to_s.sub(/\?/, '')
      }
    end
    @@roles.each do |key,value|
      define_method(value[:name]){
        key.to_s.to_i
      }
    end
  end

  def self.display id
    I18n.t 'manage.user.role.'+@@roles[id_sym(id)][:name]
  end

  def self.id_sym id
    id.to_s.to_sym
  end

  def self.role_items
    role_items=[]
    @@roles.each do |key, value|
      role_items<<RoleItem.new(id: key.to_s.to_i, name: Role.display(key))
    end
    return role_items
  end


  def self.menu
    roles = []
    @@roles.each { |key, value|
      roles <<[value[:display], key.to_s]
    }
    roles
  end
end

class RoleItem<CZ::BaseClass
  attr_accessor :id, :name
end