class Task < ApplicationRecord
  self.inheritance_column = nil
  has_many :task_users

  belongs_to :user
  belongs_to :taskable, :polymorphic => true

end
