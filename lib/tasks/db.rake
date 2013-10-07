#This is the task invoked by rake db:all . It resets the database, does all the migrations and populates the new database with fake data
namespace :db do

  task :all => [:environment, :reset, :migrate, :populate] do
  end

end
