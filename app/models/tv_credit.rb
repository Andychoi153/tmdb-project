class TvCredit < ApplicationRecord
    # references by multiple key(index)에 대한 이해 부족
    # relation 을 제대로 구축하지 못해서 controller 에 orm이 아닌 조건 절을 통한 조회
    # TODO: 위의 문제를 해결해서 보다 간결한 orm 문법으로 표시
    belongs_to :tv
    belongs_to :person

    # belongs_to :tv_season
    # belongs_to :tv_episode
end
