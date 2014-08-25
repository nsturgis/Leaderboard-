require 'pry'
require 'csv'
require 'sinatra'
require 'sinatra/reloader'

winners = []
CSV.foreach('teams.csv',headers:true,header_converters: :symbol) do |row|
 if row[:home_score].to_i > row[:away_score].to_i
    winners << row[:home_team]
  elsif row[:away_score].to_i > row[:home_score].to_i
    winners << row[:away_team]
  end
end

losers = []
CSV.foreach('teams.csv',headers:true,header_converters: :symbol) do |row|
  if row[:home_score].to_i < row[:away_score].to_i
    losers << row[:home_team]
  elsif row[:away_score].to_i < row[:home_score].to_i
    losers << row[:away_team]
  end
end

win_count = Hash.new 0
winners.each do |row|
  win_count[row] += 1
end

loss_count = Hash.new 0
losers.each do |row|
  loss_count[row] += 1
end

def find_teams
  teams = []
  CSV.foreach('teams.csv',headers:true,header_converters: :symbol) do |row|
    teams << row[:home_team]
    teams << row[:away_team]
  end
  teams.uniq
end

##======ROUTES===========#######

get '/leaderboard' do
  @team = find_teams
  @wins = win_count
  @losses = loss_count
  erb :leaders
end
