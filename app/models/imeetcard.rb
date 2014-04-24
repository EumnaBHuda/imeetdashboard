require 'active_resource'



class Imeetcard < ActiveResource::Base
  	unloadable
	self.site = "http://localhost:9000/"
    #self.format = :json
    self.format = ::JsonFormatter.new(:issues)
    self.element_name = "issues" 
    self.user = "kcecadmin"
    self.password = "bng29sam"
end
