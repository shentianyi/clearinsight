class ProjectUser < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :tenant

  acts_as_tenant(:tenant)
end
