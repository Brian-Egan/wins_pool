class AddStatToPool < ActiveRecord::Migration[5.1]
  def change
    add_column :pools, :sort_stat, :text
  end
end
