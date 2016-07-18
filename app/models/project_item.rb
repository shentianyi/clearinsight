class ProjectItem < ApplicationRecord
  belongs_to :user
  belongs_to :tenant
  belongs_to :project

  has_one :diagram, as: :diagrammable, dependent: :destroy

end