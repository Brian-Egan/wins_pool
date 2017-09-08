# == Schema Information
#
# Table name: teams
#
#  id                 :integer          not null, primary key
#  name               :string
#  wins               :integer
#  losses             :integer
#  ties               :integer
#  points_for         :integer
#  points_against     :integer
#  long_record        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  point_differential :integer
#

require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
