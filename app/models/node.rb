class Node < ApplicationRecord
  self.inheritance_column = :_type_disabled
  belongs_to :tenant
  acts_as_tenant(:tenant)

  validates :name, presence: true

  belongs_to :node_set
  has_ancestry

  before_create :init_fields

  private
  def init_fields
    self.uuid=SecureRandom.uuid
    self.code=self.uuid
  end
end
