class CreateTeamsUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :teams_users do |t|
      t.integer :team_id, foreign_key: true, index: true
      t.integer :user_id, foreign_key: true, index: true
    end
  end
end
