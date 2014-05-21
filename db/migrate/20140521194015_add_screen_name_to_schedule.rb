class AddScreenNameToSchedule < ActiveRecord::Migration
  def change
    add_column :schedules, :screen_name, :string
  end
end
