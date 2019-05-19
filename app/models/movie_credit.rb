class MovieCredit < ApplicationRecord
    belongs_to :movie
    belongs_to :person
end
