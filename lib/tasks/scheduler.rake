desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do
  puts "Executing tweets operations at #{Time.now}"
  Schedule.operation
  puts "done."
end
