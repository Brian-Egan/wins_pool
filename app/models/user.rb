# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
    has_many :teams

    def self.load_users
        [
            {name: "Laura Powers", teams: ["Colts", "Texans", "Titans"] },
            {name: "Colleen Malloy", teams: ["Seahawks", "Saints", "Redskins"] },
            {name: "Dan Vollmayer",  teams: ["Broncos", "Lions", "Browns"] },
            {name: "Brian Egan",  teams: ["Vikings", "Falcons", "Bears"] },
            {name: "Rich Rosario",  teams: ["Patriots", "49ers", "Giants"] },
            {name: "Keith", teams: ["Packers", "Dolphins", "Bills"] },
            {name: "Jay W", teams: ["Ravens", "Rams", "Panthers"] },
            {name: "RJ", teams: ["Eagles", "Chiefs", "Chargers"] },
            {name: "Matt Blaszko", teams: ["Cowboys", "Bengals", "Jets"] },
            {name: "Sean", teams: ["Cardinals", "Tampa Bay", "Steelers"] },
        ].each do |user|
            new_user = User.find_or_create_by(name: user[:name])
            user[:teams].each do |nickname|
                team = Team.where("name LIKE ?","%#{nickname}%").first
                team.update_attributes(user_id: new_user.id) if team and team.user_id.nil?
            end
        end


    end

    def self.create_users_and_associate_teams
      Team.all.each{|t| t.update_attributes(user_id: nil)}
      self.destroy_all
      users = [
          {
              name: "Brian",
              teams: ["Seahawks", "Panthers", "Vikings", "Broncos"]
          },
          {
              name: "Rob",
              teams: ["Steelers", "Chiefs", "Ravens", "Chargers"]
          },
          {
              name: "Brad",
              teams: ["Packers", "Giants", "Cardinals", "Dolphins"]
          },
          {
              name: "Charlie",
              teams: ["Falcons", "Titans", "Eagles", "Texans"]
          },
          {
              name: "Saugat",
              teams: ["Patriots", "Buccaneers", "Bengals"]
          },
          {
              name: "Laura",
              teams: ["Cowboys", "Raiders", "Lions", "Saints"]
          }
      ]
      users.each {|x| 
        # puts "Creating #{x} - who has teams #{x[:teams]}"
        u = User.create(name: x[:name])
        # puts "Created #{x}"
        x[:teams].each do |t|
          puts "Assigning #{t} to #{u.name}"
          team = Team.where("name like ?","%#{t}").first
          print "  - Team ID: #{team.id}"
          if team.nil?
            puts "No team found with name #{t}"
          else 
            team.update_attributes(user_id: u.id)
          end
        end
      }
    end

    def wins
      if self.teams
        teams.map{|x| x.wins}.sum
      end
    end

    def losses
      if self.teams
        teams.map{|x| x.losses}.sum
      end
    end

    def ties
      if self.teams
        teams.map{|x| x.ties}.sum
      end
    end

    def point_differential
      if self.teams
        teams.map{|x| x.point_differential}.sum
      end
    end


end
