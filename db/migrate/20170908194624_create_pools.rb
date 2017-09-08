class CreatePools < ActiveRecord::Migration[5.1]
  def change
    create_table :pools do |t|
      t.text :name
      t.text :long_name
      t.boolean :active
      t.text :sort_order

      t.timestamps
    end
  end
end
