require 'csv'

namespace :import_users do

  desc "Import CSV Data"
  task :import_users => [:environment] do

    csv_file_path = 'db/users.csv'

    CSV.foreach(csv_file_path) do |row|
      User.create!({
        :email => row[0],
        :encrypted_password => row[1],
        :fname => row[2], 
        :lname => row[3],
        :phone => row[4],
        :carrier => row[5],
        :confirmed_at => row[6], 
        :admin => row[7],
        :uberadmin => row[8]      
      })
      puts "Row added!"
    end
  end
end