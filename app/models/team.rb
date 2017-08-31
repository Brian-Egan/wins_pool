# == Schema Information
#
# Table name: teams
#
#  id          :integer          not null, primary key
#  name        :string
#  wins        :integer
#  losses      :integer
#  ties        :integer
#  long_record :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Team < ApplicationRecord
  belongs_to :user

  serialize :long_record, Hash

  default_scope -> { order(wins: :desc, point_differential: :desc)}

  after_update :calculate_point_differential

  # require "Nokogiri"
  require 'open-uri'


  def self.update
    doc = Nokogiri::HTML(open("http://www.nfl.com/standings"))
    standings_table = doc.xpath("//table")
    rows = doc.xpath("//table/tbody/tr")
    header_row = rows.select{|x| x.text.include?("AFC")}.first
    headers = header_row.css("td").map{|x| x.inner_text.strip}
    headers[0] = "Team" # Instead of being set to "AFC East Team"
    rows = rows.reject{|x| (x.text.include?("AFC") or x.text.include?("NFC") or x.text.include?("Conference") or x.text.empty?)}
    rows.each do |row|
        team_hsh = {}
        headers.each_with_index{|h, i| team_hsh[h] = row.css("td")[i].inner_text.strip}
        # ap team_hsh
        
        team = self.find_or_create_by(name: team_hsh["Team"])
        team.update_attributes(wins: team_hsh["W"].to_i, losses: team_hsh["L"].to_i, ties: team_hsh["T"].to_i, points_for: team_hsh["PF"].to_i, points_against: team_hsh["PA"].to_i, long_record: team_hsh)
        # ap team_hsh.map{|x| [x["Team"], x["W"]]}

        team.save if team.changed?
    end
  end

  def self.randomize
    self.all.each do |team|
      team.wins = rand(8)
      team.losses = rand(8)
      team.points_for = rand(200)
      team.points_against = rand(200)
      team.save
    end
  end

  def self.assign
    self.all.each {|t| t.update_attributes(user_id: User.all.shuffle.first.id)}
  end

  def calculate_point_differential
    self.update_attributes(point_differential: self.points_for - self.points_against) unless (self.point_differential == (self.points_for - self.points_against))
  end



  # def point_differential
  #   (self.points_for - self.points_against)
  # end


  # The team_hsh above gives us more info on teams that we can use if wanted:
    # {
    #   "Team" => "New England Patriots",
    #     "W" => "0",
    #     "L" => "0",
    #     "T" => "0",
    #   "Pct" => ".000",
    #    "PF" => "0",
    #    "PA" => "0",
    # "Net Pts" => "0",
    #    "TD" => "0",
    #  "Home" => "0-0",
    #  "Road" => "0-0",
    #   "Div" => "0-0",
    #  "Conf" => "0-0",
    # "Non-Conf" => "0-0",
    # "Streak" => "--",
    # "Last 5" => "0-0"
    # }

    # We should definitely add PF and PA as a tie-breaker between teams with the same amount of wins.

  # (x.text.include?("AFC") or x.text.include?("NFC") or x.text.include?("Conference") or x.text.empty?)



end
