class TvEpisode < ApplicationRecord
    # relation 아직 파악 필요, 해당 주석 풀면 저장 안되는 현상
    # belongs_to :tv_season
    has_many :person, :through => :tv_credits
end
