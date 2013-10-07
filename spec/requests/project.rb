# this model supports the Project table
class Project < ActiveRecord::Base
  belongs_to :lifecycle  
  has_many :project_users
  has_many :users, :through => :project_users  
  has_many :deliverables
  
  # return all phases for the project
  def phases
    lifecycle.phases  
  end
  
  # get the project's deliverables for a given user
  def deliverables_for_user(user)
    deliverables.find(:all, :include => [:users], :conditions => { "users.id" => user.id })
  end
  
  # get the users who are not on the project
  def users_not_on_project
    User.find(:all) - self.users
  end

end