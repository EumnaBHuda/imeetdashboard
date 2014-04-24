class ImdashsController < ApplicationController
  unloadable
  before_filter :require_login
  caches_action :robots
  helper :issues
  include IssuesHelper
  helper :projects
  helper :queries
  include QueriesHelper
 
 
  helper :members 
  helper :users
  helper :custom_fields 
  helper :sort
  include SortHelper
  helper :projects
  include ProjectsHelper

  

    def index
        
        @project_peoples = []
        scope = Project
        #@pusers = users
        #@projectss = scope.visible.order('lft').all
       
        @projects = Project.latest User.current
        #Rails.logger.info "DEBUG STARTED"
        @projectss = User.current.memberships.collect(&:project).compact.select(&:active?).uniq
        #puts @projectss
        #Rails.logger.info "DEBUG END"
        @news = News.latest User.current
        @users = User.all
        @user = User.current
       # Rails.logger.info "Start Debugging"
       
        @persons = Person.all.reverse
        
       # Rails.logger.info "Persons data #{@persons}"
       # Rails.logger.info "End Debugging"

        @issues  = Issue.order("created_on DESC").all
        userCurrent = User.current.id
        @issuesAssignedToMeOriginal = Issue.where assigned_to_id: User.current.id
        @issuesAssignedToMe = @issuesAssignedToMeOriginal.where tracker_id: 5
        @issuesAssignedToMe = @issuesAssignedToMe.where(status_id: [1,2,3,4])
        @issuesAssignedToMe = @issuesAssignedToMe.reverse
      

        @tasksAssignedToMeOriginal = Issue.where assigned_to_id: User.current.id
        @tasksAssignedToMe = @tasksAssignedToMeOriginal.where tracker_id: 4 
        @tasksAssignedToMe = @tasksAssignedToMe.where(status_id: [1,2,3,4])
        @tasksAssignedToMe = @tasksAssignedToMe.reverse
        
        #@tasks = TodoList.all

        @allFiles = Attachment.all.reverse  
        
       # @callers = Caller.all
        @year ||= Date.today.year #returns 2013
      
        @month ||= Date.today.month #returns 12
        @calendarLocal = Redmine::Helpers::Calendar.new(Date.civil(@year,@month), current_language, :week)
        print @calendarLocal
        retrieve_query
        @query.group_by = nil
        if @query.valid?
           events = []
           events += @query.issues(:include => [:tracker, :assigned_to, :priority],
                                  :conditions => ["((start_date BETWEEN ? AND ?) OR (due_date BETWEEN ? AND ?))", @calendarLocal.startdt, @calendarLocal.enddt, @calendarLocal.startdt, @calendarLocal.enddt]
                                  )
           events += @query.versions(:conditions => ["effective_date BETWEEN ? AND ?", @calendarLocal.startdt, @calendarLocal.enddt])#

       @calendarLocal.events = events
=begin
       @projectss.each do |project|
         Rails.logger.info "Start Debugging #{project}"
         @project_people = project.users
         puts @project_people
         Rails.logger.info "End Debugging"
        end
=end

   
   
    end
     # sorting tasks of users
    retrieve_query
    sort_init(@query.sort_criteria.empty? ? [['id', 'desc']] : @query.sort_criteria)
    sort_update(@query.sortable_columns)
    @query.sort_criteria = sort_criteria.to_a
    
    #Rails.logger.info "Debug tasks"
    #@pro = params[:project_id]
    #@proid = Projects.where(:name => @pro).pluck(:id)
    if @query.valid?
      case params[:format]
      when 'csv', 'pdf'
        @limit = Setting.issues_export_limit.to_i
      when 'atom'
        @limit = Setting.feeds_limit.to_i
      when 'xml', 'json'
        @offset, @limit = api_offset_and_limit
      else
        @limit = per_page_option
      end

    #@tasks = Issue.where(:tracker_id => 4)
     @tasks = @query.issues(:include => [:assigned_to, :tracker, :priority, :category, :fixed_version],
                              :order => sort_clause,
                              :offset => @offset,
                              :limit => @limit
                              )
     #@tasks =  @tasks.reject{| v| v.tracker.to_s == 'Issue'}
     #@tasks = @tasks.where(status_id: [1,2,5])
   # @list_tasks = @tasks.where(:tracker_id => 4)
    
      @issue_count = @tasks.count
      @issue_pages = Paginator.new @issue_count, @limit, params['page']
      @offset ||= @issue_pages.offset 
    Rails.logger.info "Debug tasks"
     
      puts @tasks.count
    Rails.logger.info "Debug tasks end"
end

end
def tasks
    retrieve_query
    sort_init(@query.sort_criteria.empty? ? [['id', 'desc']] : @query.sort_criteria)
    sort_update(@query.sortable_columns)
    @query.sort_criteria = sort_criteria.to_a
    
    #Rails.logger.info "Debug tasks"
    #@pro = params[:project_id]
    #@proid = Projects.where(:name => @pro).pluck(:id)
    if @query.valid?
      case params[:format]
      when 'csv', 'pdf'
        @limit = Setting.issues_export_limit.to_i
      when 'atom'
        @limit = Setting.feeds_limit.to_i
      when 'xml', 'json'
        @offset, @limit = api_offset_and_limit
      else
        @limit = per_page_option
      end

    #@tasks = Issue.where(:tracker_id => 4)
     @tasks = @query.issues(:include => [:assigned_to, :tracker, :priority, :category, :fixed_version],
                              :order => sort_clause,
                              :offset => @offset,
                              :limit => @limit
                              )
     @tasks =  @tasks.reject{| v| v.tracker.to_s == 'Issue'}
     #@tasks = @tasks.where(status_id: [1,2,5])
   # @list_tasks = @tasks.where(:tracker_id => 4)
    
      @issue_count = @tasks.count
      @issue_pages = Paginator.new @issue_count, @limit, params['page']
      @offset ||= @issue_pages.offset 
    Rails.logger.info "Debug tasks"
     
      puts @tasks.count
    Rails.logger.info "Debug tasks end"
end
    
end

def robots
    @projects = Project.all_public.active
    render :layout => false, :content_type => 'text/plain'
  end

  


end
