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
    rows.each do |row|
        unless (row.text.include?("AFC") or row.text.include?("NFC") or row.text.include?("Conference") or row.text.empty?)
            record = row.css("td").map{|x| x.text.strip}[0..3]
            team = self.find_or_create_by(name: record[0])
            team.update_attributes(wins: record[1], losses: record[2], ties: record[3])
            # team.save if team.changed?
            team.save
        end
    end

  end



end
