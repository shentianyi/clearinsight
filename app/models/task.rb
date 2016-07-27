class Task < ApplicationRecord
  self.inheritance_column = nil
  has_many :task_users, dependent: :destroy
  has_many :accessers, through: :task_users, source: :user, dependent: :destroy

  belongs_to :user
  belongs_to :taskable, :polymorphic => true


  # before_create :init_default_task_user

  def init_default_task_user
    self.task_users.build(user_id: self.user_id, task_id: self.id)
  end

end
