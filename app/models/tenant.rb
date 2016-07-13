class Tenant < ApplicationRecord
 has_many :users
 belongs_to :super_user ,:class_name=>'User',:foreign_key=>'user_id'
end
