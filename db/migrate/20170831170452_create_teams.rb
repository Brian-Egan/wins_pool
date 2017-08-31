class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :wins
      t.integer :losses
      t.integer :ties
      t.integer :points_for
      t.integer :points_against
      t.text :long_record
      t.belongs_to :user, foreign_key: true, index: true

      t.timestamps
    end
  end
end
