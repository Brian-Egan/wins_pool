task :load_users => :environment do
   # puts "Hello world"
   # Team.update
   User.load_users
end