class PersonController < ApplicationController
  skip_before_action :verify_authenticity_token

    def info
      data = Person.new
      data.person_id = params[:person_id]
      data.name = params[:name]
      data.profile_path = params[:profile_path]
      data.save
      render status: 200, json: {
        message: "Successfully #{params[:person_id]} insert."
      }.to_json
    end

    def get
      id = params[:id]
      person = Person.find(id)

      # primary key
      @person = person
      @tv = person.tvs.all.uniq
      @movie = person.movies.all.uniq
    end
end
