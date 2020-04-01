class CreateConferences < ActiveRecord::Migration[6.0]
  def change
    create_table :conferences do |t|
      t.integer :pbx_id
      t.datetime :ended_at
      t.datetime :started_at
      t.references :dialer, foreign_key: true
      t.timestamps
    end
  end
end
