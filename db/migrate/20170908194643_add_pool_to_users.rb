class AddPoolToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :pool_id, :integer, foreign_key: true, index: true
    remove_column :teams, :user_id
  end
end
