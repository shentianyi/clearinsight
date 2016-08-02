class Record < ApplicationRecord
  belongs_to :user
  belongs_to :tenant

  belongs_to :logable, polymorphic: true
  belongs_to :recordable, polymorphic: true

  acts_as_tenant(:tenant)
end
