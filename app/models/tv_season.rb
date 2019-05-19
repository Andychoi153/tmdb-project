class TvSeason < ApplicationRecord
    belongs_to :tv
    has_many :tv_episode
    has_many :person, :through => :tv_credits
end
