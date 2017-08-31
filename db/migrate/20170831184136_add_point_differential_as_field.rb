class AddPointDifferentialAsField < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :point_differential, :integer
  end
end
