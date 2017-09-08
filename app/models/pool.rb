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

class Pool < ApplicationRecord
  has_many :users



  def self.initial_info
    pools = [
      {
        name: "Wins Pool",
        long_name: "2017 NFL Wins Pool",
        active: true,
        sort_order: :wins_desc,
        sort_stat: :wins,
        users: [
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
      },
      {
        name: "Loss Pool",
        long_name: "2017 NFL Losses Pool",
        active: true,
        sort_order: :losses_desc,
        sort_stat: :losses,
        users: [
          {
            name: "Brian",
            teams: ["49ers", "Redskins", "Ravens"]
          },
          {
            name: "Rob",
            teams: ["Bears", "Colts","Broncos"]
          },
          {
            name: "Brad",
            teams: ["Rams", "Chargers", "Saints"]
          },
          {
            name: "Charlie",
            teams: ["Browns", "Dolphins", "Lions"]
          },
          {
            name: "Saugat",
            teams: ["Bills", "Jaguars"]
          },
          {
            name: "Laura",
            teams: ["Jets", "Eagles", "Vikings"]
          }
        ]
      }
    ]
    pools 
  end




  def self.init_pools
    Team.destroy_all
    Pool.destroy_all
    User.destroy_all
    Team.update 
    pools = initial_info 
    pools.each do |p|
      pool = Pool.create(name: p[:name], long_name: p[:long_name], active: p[:active], sort_order: p[:sort_order], sort_stat: p[:sort_stat])
      p[:users].each do |u|
        user = User.create(name: u[:name], pool_id: pool.id)
        teams = u[:teams].map{|t| Team.where("name like ?", "%#{t}%").first}
        user.teams = teams
        user.save
        # user[:teams].each do {|t| user.add_team_by_name(t)}
      end
    end
  end

  def standings
    # @teams = Team.send(self.sort_order)
    @teams = case self.sort_order 
    when :wins_desc 
      Team.order(wins: :desc, point_differential: :desc)
    when :losses_desc
      Team.order(losses: :desc, point_differential: :asc)
    else
      Team.all 
    end
    @teams
  end






end
