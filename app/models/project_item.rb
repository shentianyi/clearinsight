class ProjectItem < ApplicationRecord
  belongs_to :user
  belongs_to :tenant
  belongs_to :project

  acts_as_tenant(:tenant)

  has_one :diagram, as: :diagrammable, dependent: :destroy
  has_one :node_set, through: :diagram
  has_many :nodes, through: :diagram
  has_many :pdca_items, :as => :taskable, :dependent => :destroy

  belongs_to :source_project_item,class_name:'ProjectItem',foreign_key: :source_id

  before_create :init_diagram
  after_create :create_kpi_setting
  before_destroy :destroy_kpi_setting

  def kpi_settings
    KpiBase.settings(self)
  end

  def self.generate_name
    "LC#{(Time.now.to_f*1000).to_i}"
  end

  def create_pdca params, user
    if params[:item].blank? || params[:due_time].blank?
      return {result: false, content: '需改进项和截止日期不能为空'}
    else
      pdca_item=PdcaItem.new({
                                 title: params[:item],
                                 content: params[:improvement_point],
                                 due_time: params[:due_time],
                                 status: TaskStatus::ON_GOING
                             })
      pdca_item.taskable=self
      pdca_item.user=user

      params[:emails].each do |email|
        pdca_item.task_users.new({task_id: pdca_item.id, user: User.find_by_email(email)})
      end

      if pdca_item.save
        {
            result: true,
            project_item: self,
            pdca: pdca_item,
            owner: pdca_item.owners_info,
            content: 'succ'
        }
      else
        {result: false, content: pdca_item.errors.messages}
      end
    end
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
        pdca_result=project_item.create_pdca params, user
        if !pdca_result[:result]
          raise pdca_result.content
        end

        layout=JSON.parse(source.diagram.layout, symbolize_names: true)
        layout[:nodeDataArray].each_with_index do |n, index|
          if source_node=Node.find_by_id(n[:key])
            node=Node.create({
                                 type: source_node.type,
                                 name: source_node.name,
                                 code: source_node.code,
                                 is_selected: source_node.is_selected,
                                 uuid: source_node.uuid,
                                 devise_code: source_node.devise_code,
                                 node_set: project_item.node_set,
                                 tenant: user.tenant
                             })
            layout[:nodeDataArray][index][:key] = node.id
          end
        end
        puts layout.to_json
        project_item.diagram.update_attributes({layout: layout.to_json})

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