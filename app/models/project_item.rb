class ProjectItem < ApplicationRecord
  include Extensions::LOGABLE

  belongs_to :user
  belongs_to :tenant
  belongs_to :project

  acts_as_tenant(:tenant)

  has_one :diagram, as: :diagrammable, dependent: :destroy
  has_one :node_set, through: :diagram
  has_many :nodes, through: :diagram
  has_many :pdca_items, :as => :taskable, :dependent => :destroy

  belongs_to :source_project_item, class_name: 'ProjectItem', foreign_key: :source_id

  has_many :logs, :as => :logable, class_name: 'Record', :dependent => :destroy

  before_create :init_diagram
  after_create :create_kpi_setting
  before_destroy :destroy_kpi_setting

  def kpi_settings
    KpiBase.settings(self)
  end

  private

  def init_diagram
    # build new diagram
    self.build_diagram(name: "#{self.project.name}_IES_#{self.project.project_items.count+1}", tenant_id: self.tenant_id)
  end

  def create_kpi_setting
    KpiBase.create_settings(self)
  end

  def destroy_kpi_setting
    KpiBase.destroy_settings(self)
  end
end