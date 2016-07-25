class Task < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :user
  belongs_to :taskable, :polymorphic => true

end
