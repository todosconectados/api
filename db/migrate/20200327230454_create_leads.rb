class CreateLeads < ActiveRecord::Migration[6.0]
  def change
    create_table :leads do |t|
      t.string :name, null: false
      t.string :company_name
      t.string :email
      t.string :phone, null: false
      t.string :comments, null: false
      t.timestamps
    end
  end
end
