class User < ActiveRecord::Base
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
            {name: "Sean", teams: ["Cardinals", "Bucs", "Steelers"] },
        ].each do |user|
            new_user = User.create(name: user[:name])
            user[:teams].each do |nickname|
                team = Team.where("name LIKE ?","%#{nickname}%").first
                team.update_attributes(user_id: new_user.id) if team
            end
        end


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

end
