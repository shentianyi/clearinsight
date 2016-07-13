class Project < ApplicationRecord
  belongs_to :user
  belongs_to :tenant
  has_many :project_users, :dependent => :destroy
  has_many :users, through: :project_users
  belongs_to :user

  after_create :create_default_project_user

  def create_default_project_user
    self.project_users.create(user_id: self.user_id, project_id: self.id, tenant_id: self.tenant_id)
  end
end
