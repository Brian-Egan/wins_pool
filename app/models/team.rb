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

class Team < ApplicationRecord
  # belongs_to :user

  has_and_belongs_to_many :users

  serialize :long_record, Hash

  # default_scope -> { order(wins: :desc, point_differential: :desc)}

  after_update :calculate_point_differential

  # require "Nokogiri"
  require 'open-uri'
  require "json"

  def self.update_interval
    min = 20
    return (min * 60)
  end

  def self.should_auto_update?
    if ((Time.now - self.order(updated_at: :desc).first.updated_at) >= update_interval)
      self.update 
    end
  end


def self.update
  url = "https://api.mysportsfeeds.com/v1.1/pull/nfl/2017-regular/overall_team_standings.json?teamstats=W,L,T,PF,PA"
  page = Nokogiri::HTML(open(url, http_basic_authentication: ["BrianEgan","BananaUmbrella"]))
  resp = JSON.parse(page)
  teams = resp["overallteamstandings"]["teamstandingsentry"]
  teams.each do |teamjson|
    team = self.find_or_create_by(name: "#{teamjson['team']['City']} #{teamjson['team']['Name']}")
    if team 
      stats = teamjson['stats']
      wins = stats['Wins']['#text'].to_i
      losses = stats['Losses']['#text'].to_i
      ties = stats['Ties']['#text'].to_i
      points_for = stats['PointsFor']['#text'].to_i
      points_against = stats['PointsAgainst']['#text'].to_i
      team.update_attributes(wins: wins, losses: losses, ties: ties, points_for: points_for, points_against: points_against, long_record: teamjson)
    end
  end
end



def self.old_update
    # url = "https://www.nfl.com/standings" # No longer using NFL.com's standings table.
    url = "http://www.espn.com/nfl/standings/_/group/league"
    doc = Nokogiri::HTML(open(url))
    header_row = doc.css("table.standings > thead.standings-categories > th")
    headers = header_row.map{|x| x.inner_text.strip}
    headers[0] = "Team" # Instead of being set to "AFC East Team"
    rows = doc.css("tr.standings-row")
    rows.each do |row|
        team_hsh = {}
        headers.each_with_index{|h, i| team_hsh[h] = row.css("td")[i].inner_text.strip}
        team_hsh["Team"] = team_hsh["Team"][0...-3] # To correct for ESPN's standings table appending each team's 3 letter abbrieviated name     
        team = self.find_or_create_by(name: team_hsh["Team"])
        team.update_attributes(wins: team_hsh["W"].to_i, losses: team_hsh["L"].to_i, ties: team_hsh["T"].to_i, points_for: team_hsh["PF"].to_i, points_against: team_hsh["PA"].to_i, long_record: team_hsh)
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
