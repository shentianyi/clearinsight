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
    self.uuid=SecureRandom.uuid if self.uuid.blank?
    self.code=self.uuid if self.code.blank?
  end
end
