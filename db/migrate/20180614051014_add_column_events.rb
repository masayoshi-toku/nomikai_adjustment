class AddColumnEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :url_path, :string
  end
end
