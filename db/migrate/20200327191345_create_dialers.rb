class CreateDialers < ActiveRecord::Migration[6.0]
  def change
    create_table :dialers do |t|
      t.integer :status, default: 0
      t.string :did
      t.string :conference_code
      t.datetime :assigned_at
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
