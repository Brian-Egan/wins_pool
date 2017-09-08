# == Schema Information
#
# Table name: pools
#
#  id         :integer          not null, primary key
#  name       :text
#  long_name  :text
#  active     :boolean
#  sort_order :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class PoolTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
