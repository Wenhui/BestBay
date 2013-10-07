#Taken from http://stackoverflow.com/questions/1574797/how-to-load-dbseed-data-into-test-database-automatically
namespace :db do
  namespace :test do
    task :load => :environment do
      Rake::Task["db:seed"].invoke
    end
  end
end