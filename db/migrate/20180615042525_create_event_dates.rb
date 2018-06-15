class CreateEventDates < ActiveRecord::Migration[5.2]
  def change
    create_table :event_dates do |t|
      t.references :event
      t.string :event_date

      t.timestamps
    end

    add_index :event_dates, [:event_id, :event_date], unique: true
  end
end
