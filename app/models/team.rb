class Team < ActiveRecord::Base
  belongs_to :user

  default_scope {order("wins DESC")}

  # require "Nokogiri"
  require 'open-uri'


  def self.update
    doc = Nokogiri::HTML(open("http://www.nfl.com/standings"))
    standings_table = doc.xpath("//table")
    # standings = Array.new
    # t = Team.create(name: "The test worked")
    rows = doc.xpath("//table/tbody/tr")
    header_row = rows.select{|x| x.text.include?("AFC")}.first
    headers = hr.css("td").map{|x| x.inner_text.strip}
    headers[0] = "Team" # Instead of being set to "AFC East Team"
    rows = rows.reject{|x| (x.text.include?("AFC") or x.text.include?("NFC") or x.text.include?("Conference") or x.text.empty?)}
    rows.each do |row|
        # unless (row.text.include?("AFC") or row.text.include?("NFC") or row.text.include?("Conference") or row.text.empty?)
        team_hsh = {}
        headers.each_with_index{|h, i| team[h] = row[i]}
        team = self.find_or_create_by(name: team_hsh["Team"])
        team.update_attributes(wins: team_hsh["W"].to_i, losses: team_hsh["L"].to_i, ties: team_hsh["T"].to_i)
        team.save

        ## Below is old way from 2015
        # unless (row.text.include?("AFC") or row.text.include?("NFC") or row.text.include?("Conference") or row.text.empty?)
        # record = row.css("td").map{|x| x.text.strip}[0..3]
        # team = self.find_or_create_by(name: record[0])
        # team.update_attributes(wins: record[1], losses: record[2], ties: record[3])
        # # team.save if team.changed?
        # team.save
        # end
    end

  end


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
