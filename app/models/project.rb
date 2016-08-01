class Project < ApplicationRecord
  # validates_uniqueness_of :name, :message => "项目名已存在!"
  validates :name, length: { maximum: 255, too_long: '项目名称长度最大为255' }
  validates :description, length: { maximum: 255, too_long: '项目描述长度最大为255' }

  belongs_to :user
  belongs_to :tenant
  has_many :project_users, :dependent => :destroy
  has_many :users, through: :project_users
  has_many :plans, :as => :taskable, :dependent => :destroy
  has_many :project_items, :dependent => :destroy

  has_many :diagrams,through: :project_items, :dependent => :destroy


  #default_scope { where(status: ProjectStatus::ON_GOING) }

  scope :ongoings,->{where(status: ProjectStatus::ON_GOING)}

  before_create :init_project_default_option

  acts_as_tenant(:tenant)


  def init_project_default_option
    self.project_users.build(user_id: self.user_id, project_id: self.id, tenant_id: self.tenant_id, role: Role.admin)
    self.project_items.build({
                                     user_id: self.user_id,
                                     tenant_id: self.tenant_id,
                                     status: ProjectItemStatus::ON_GOING,
                                     name: self.generate_item_name
                                 })
  end

  def generate_item_name
    "R#{self.project_items.count + 1}"
  end

  def a

  end
end
