class CreateApiKeys < ActiveRecord::Migration[6.0]
  def change
    create_table :api_keys do |t|
      t.string :api_id
      t.string :api_key

      t.timestamps
    end
  end
end
