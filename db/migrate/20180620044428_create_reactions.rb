class CreateReactions < ActiveRecord::Migration[5.2]
  def change
    create_table :reactions do |t|
      t.references :user, foreign_key: true, null: false
      t.references :event_date, foreign_key: true, null:false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
