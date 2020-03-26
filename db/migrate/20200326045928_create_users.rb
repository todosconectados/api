class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :last_names
      t.string :email
      t.string :phone, null: false
      t.integer :status, default: 0
      t.string :activation_code
      t.integer :target, null: false
      t.string :business_name, null: false
      t.integer :industry, default: 0
      t.integer :state, null: false
      t.timestamps
    end
  end
end
