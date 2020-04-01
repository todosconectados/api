class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :last_names, null: false
      t.string :email, null: false
      t.string :phone
      t.integer :status, default: 0
      t.string :activation_code
      t.timestamps
    end
  end
end
