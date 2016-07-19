class ProjectItem < ApplicationRecord
  belongs_to :user
  belongs_to :tenant
  belongs_to :project

  acts_as_tenant(:tenant)

  has_one :diagram, as: :diagrammable, dependent: :destroy
  has_one :node_set, through: :diagram
  has_many :nodes, through: :diagram

  before_create :init_diagram
  after_create :init_kpi_setting


  def kpi_settings
    KpiBase.settings(self)
  end

  private

  def init_diagram
    # build new diagram
    self.build_diagram(name: "#{self.project.name}_IES_#{self.project.project_items.count+1}", tenant_id: self.tenant_id)
  end

  def init_kpi_setting
    KpiBase.build_settings(self)
  end
end