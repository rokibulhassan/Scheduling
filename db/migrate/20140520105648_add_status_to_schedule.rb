class AddStatusToSchedule < ActiveRecord::Migration
  def change
    add_column :schedules, :user_id, :integer
    add_column :schedules, :status, :boolean, :default => false
  end
end
