class Schedule < ActiveRecord::Base

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Schedule.create!(row.to_hash)
    end
  end

end
