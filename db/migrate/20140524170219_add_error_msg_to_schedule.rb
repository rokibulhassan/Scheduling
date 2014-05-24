class AddErrorMsgToSchedule < ActiveRecord::Migration
  def change
    add_column :schedules, :error_msg, :string
  end
end
