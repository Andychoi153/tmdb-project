class Person < ApplicationRecord
    self.primary_key = :person_id
    has_many :movie_credits
    has_many :tv_credits
    has_many :movies, :through => :movie_credits
    has_many :tvs, :through => :tv_credits
    has_many :tv_seasons, :through => :tv_credits
    has_many :tv_episodes, :through => :tv_credits
end
