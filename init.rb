Redmine::Plugin.register :imeetdashboard do
  name 'Imeetdashboard plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  menu :project_menu, :imdashs, {:controller => 'imdashs', :action => 'index'}, :caption => "check", :after => :activity
end
