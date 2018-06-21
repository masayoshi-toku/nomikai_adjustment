class CreateReactions < ActiveRecord::Migration[5.2]
  def change
    create_table :reactions do |t|
      t.references :user, foreign_key: true
      t.references :event_date, foreign_key: true
      t.integer :status, null: false

      t.timestamps
    end
  end
end
