class Plan < Task
  belongs_to :user

  default_scope { where(type: TaskType::PLAN) }

end
