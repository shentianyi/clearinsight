class ProjectItem < ApplicationRecord
  belongs_to :user
  belongs_to :tenant
  belongs_to :project

  acts_as_tenant(:tenant)

  has_one :diagram, as: :diagrammable, dependent: :destroy
  has_one :node_set, through: :diagram
  has_many :nodes, through: :diagram
  has_many :pdca_items, :as => :taskable, :dependent => :destroy

  before_create :init_diagram
  after_create :create_kpi_setting
  before_destroy :destroy_kpi_setting

  def kpi_settings
    KpiBase.settings(self)
  end

  def self.generate_name
    "LC#{(Time.now.to_f*1000).to_i}"
  end


  def self.test params
    ProjectItem.transaction do
      user = User.find_by_email('admin@ci.com')
      if project=Project.find_by_id(params[:project_id])
        source=project.project_items.last
        project_item=project.project_items.create({
                                                      user: user,
                                                      tenant: user.tenant,
                                                      status: ProjectItemStatus::ON_GOING,
                                                      name: ProjectItem.generate_name,
                                                      source_id: source.id
                                                  })
        puts '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
        puts source.diagram.layout


        layout=JSON.parse(source.diagram.layout, symbolize_names: true)
        layout[:nodeDataArray].each_with_index do |n, index|
          node=Node.create({
                               type: n[:returnParams][:type],
                               name: n[:returnParams][:name],
                               code: n[:returnParams][:code],
                               is_selected: n[:returnParams][:is_selected],
                               uuid: n[:returnParams][:uuid],
                               devise_code: n[:returnParams][:devise_code],
                               node_set: project_item.node_set,
                               tenant: user.tenant
                           })
          puts "-----------------------------------------------------------------------------------"
          puts "------------t#{n[:returnParams][:id]}-------- t#{node.id}----------------------"
          puts "------------t#{n[:returnParams][:node_set_id]}--------t#{project_item.node_set.id}----------------------"
          layout[:nodeDataArray][index][:returnParams][:id] = node.id
          layout[:nodeDataArray][index][:returnParams][:node_set_id] = project_item.node_set.id
          puts "----------------------------------------------------------------------------------------------"
        end
        puts layout.to_json
        project_item.diagram.update_attributes({layout: layout})

      end
    end
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