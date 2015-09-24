require "Nokogiri"
require 'open-uri'

def display_standings
    doc = Nokogiri::HTML(open("http://www.nfl.com/standings"))
    standings_table = doc.xpath("//table")
    standings = Array.new
    discard_rows_that_contain = ["AFC","NFC","Conference"]
    rows = doc.xpath("//table/tbody/tr")
    rows.each do |row|
        unless (row.text.include?("AFC") or row.text.include?("NFC") or row.text.include?("Conference") or row.text.empty?)
            record = row.css("td").map{|x| x.text.strip}[0..3]
            standings << {name: record[0], wins: record[1].to_i, losses: record[2].to_i, ties: record[3].to_i}
        end
    end
    standings
end



