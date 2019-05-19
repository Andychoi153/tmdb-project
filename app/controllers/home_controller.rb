class HomeController < ApplicationController
  def index
    tv = Tv.order('RAND()').last(10)
    movie = Movie.order('RAND()').last(10)
    people = Person.order('RAND()').last(10)

  
    @tv = tv
    @movie = movie
    @people = people
  end
end
