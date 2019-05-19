class MovieController < ApplicationController
  skip_before_action :verify_authenticity_token

    def info
      data = Movie.new
      data.movie_id = params[:movie_id]
      data.title = params[:title]
      data.poster_path = params[:poster_path]
      data.vote_average = params[:vote_average]
      data.vote_count = params[:vote_count]
      data.save
      render status: 200, json: {
        message: "Successfully movie #{params[:movie_id]} insert."
      }.to_json
    end

    def credit
        data = MovieCredit.new
        data.movie_id = params[:movie_id]
        data.person_id = params[:person_id]
        data.role = params[:role]
        data.save
        render status: 200, json: {
          message: "Successfully movie #{params[:movie_id]} person #{params[:person_id]} credit insert."
        }.to_json
    end

    def get
      id = params[:id]
      movie = Movie.find(id)
      @movie = movie
      @crew = movie.people.where("role = ?", "crew")
      @cast = movie.people.where("role = ?", "cast")
    end
  end