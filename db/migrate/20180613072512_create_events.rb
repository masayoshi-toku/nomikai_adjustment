class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.references :user, foreign_key: true
      t.string :title

      t.timestamps
    end

    add_index :events, [:user_id, :title], unique: true
  end
end
