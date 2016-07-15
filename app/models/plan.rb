class Plan < Task
  belongs_to :user

  default_scope { where(type: TaskType::PLAN) }


  def self.add_plan params
    msg=Message.new(result: true, object: [], contents: [])

    unless params.blank?
      params.keys.each do |key|
        if params[key][:dateTo].to_date > params[key][:dateFrom].to_date
          msg.object<<{start_time: params[key][:dateFrom], end_time: params[key][:dateTo], title: params[key][:name]}
        else
          msg.contents << "计划：#{params[key][:name]}开始日期大于结束日期"
        end
      end
      unless msg.result=(msg.contents.size==0)
        msg.content=msg.contents.join('/')
      end
    end

    msg
  end

end
