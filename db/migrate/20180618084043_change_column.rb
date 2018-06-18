class ChangeColumn < ActiveRecord::Migration[5.2]
  def change
    change_column :event_dates, :event_id, :integer, null: false
    change_column :event_dates, :event_date, :string, null: false
    change_column :events, :user_id, :integer, null: false
    change_column :events, :title, :string, null: false
    change_column :events, :url_path, :string, null: false
    change_column :users, :name, :string, null: false
    change_column :users, :email, :string, null: false
  end
end
