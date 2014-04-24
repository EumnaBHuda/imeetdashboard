module ImdashsHelper

	def issuesassignedtome_items
    Issue.visible.open.
      where(:assigned_to_id => ([User.current.id] + User.current.group_ids)).
      limit(10).
      includes(:status, :project, :tracker, :priority).
      order("#{IssuePriority.table_name}.position DESC, #{Issue.table_name}.updated_on DESC").
      all
  end

  def calendar_items(startdt, enddt)
    Issue.visible.
      where(:project_id => User.current.projects.map(&:id)).
      where("(start_date>=? and start_date<=?) or (due_date>=? and due_date<=?)", startdt, enddt, startdt, enddt).
      includes(:project, :tracker, :priority, :assigned_to).
      all
  end
end
