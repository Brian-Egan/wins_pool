# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  pool_id    :integer
#

class User < ApplicationRecord
    # has_many :teams
    has_and_belongs_to_many :teams
    belongs_to :pool

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

    def self.init_anew
      Team.destroy_all
      self.destroy_all
      Team.update 
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
        u = User.User.find_or_create_by(name: x[:name])

      }
  end

    def self.create_users_and_associate_teams
      # Team.all.each{|t| t.update_attributes(user_id: nil)}
      Team.all.each{|t| t.update_attributes(users: [])}
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
        u = User.find_or_create_by(name: x[:name])
        # puts "Created #{x}"
        x[:teams].each do |t|
          # puts "Assigning #{t} to #{u.name}"
          # team = Team.where("name like ?","%#{t}").first
          # print "  - Team ID: #{team.id}"
          # if team.nil?
          #   puts "No team found with name #{t}"
          # else 
          #   team.update_attributes(user_id: u.id)
          # end
          u.add_team_by_name(t) if u
        end
      }
    end

    def add_team_by_name(team_name)
      team = Team.where("name like ?","%#{team_name}").first
      # self.teams << team 
      team.users << self
      team.save
      # self.save
      # team.update_attributes(user_id: u.id) unless team.nil?
    end

    def sort_stat
      self.send(self.pool.sort_stat)
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
