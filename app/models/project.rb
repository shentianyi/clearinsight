class Project < ApplicationRecord
  # validates_uniqueness_of :name, :message => "项目名已存在!"

  belongs_to :user
  belongs_to :tenant
  has_many :project_users, :dependent => :destroy
  has_many :users, through: :project_users
  belongs_to :user
  has_many :plans, :as => :taskable, :dependent => :destroy
  has_many :project_items, :dependent => :destroy

  has_many :diagrams,through: :project_items

  default_scope { where(status: ProjectStatus::ON_GOING) }

  after_create :create_default_project_user

  acts_as_tenant(:tenant)


  def create_default_project_user
    self.project_users.create(user_id: self.user_id, project_id: self.id, tenant_id: self.tenant_id, role: Role.admin)
  end
end
