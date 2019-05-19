class TvController < ApplicationController
    skip_before_action :verify_authenticity_token

    def info
        data = Tv.new
        data.tv_id = params[:tv_id]
        data.name = params[:name]
        data.poster_path = params[:poster_path]
        data.vote_average = params[:vote_average]
        data.vote_count = params[:vote_count]
        # 일단 db insertion check 만
        data.save
        render status: 200, json: {
            message: "Successfully tv #{params[:tv_id]} insert."
        }.to_json
    end

    def season
        data = TvSeason.new
        data.tv_id = params[:tv_id]
        data.season_number = params[:season_number]
        data.poster_path = params[:poster_path]
        data.save
        render status: 200, json: {
            message: "Successfully tv #{params[:tv_id]} season #{params[:season_number]} insert."
        }.to_json
    end

    def episode
        data = TvEpisode.new
        data.tv_id = params[:tv_id]
        data.season_number = params[:season_number]
        data.episode_number = params[:episode_number]
        data.still_path = params[:still_path]
        data.vote_average = params[:vote_average]
        data.vote_count = params[:vote_count]
        data.save
        render status: 200, json: {
            message: "Successfully tv #{params[:tv_id]} season #{params[:season_number]} episode #{params[:episode_number]} insert."
        }.to_json
    end

    def credit
        data = TvCredit.new
        data.tv_id = params[:tv_id]
        data.season_number = params[:season_number]
        data.episode_number = params[:episode_number]
        data.person_id = params[:person_id]
        data.role = params[:role]
        data.save
        render status: 200, json: {
            message: "Successfully tv #{params[:tv_id]} person #{params[:person_id]} credit insert."
        }.to_json
    end

    def get_info
        id = params[:id]
        tv = Tv.find(id)
        @tv = tv
        @season = TvSeason.where("tv_id = ?", id)
        @crew = tv.people.where("role = ?", "crew").uniq
        @cast = tv.people.where("role = ?", "cast").uniq
    end

    def get_season
        # multiple primary key, & references by multiple key에 대한 이해 부족
        # relation 을 제대로 구축하지 못해서 아래와 같이 추가적인 조건 절 이 붙음
        # TODO: 위의 문제를 해결해서 보다 간결한 orm 문법으로 표시
        id = params[:id]
        season_number = params[:season_number]

        tv_episodes = TvEpisode.where("tv_id = ?", id).
        where("season_number = ?", season_number)
        
        crew_people_ids = TvCredit.select("person_id").where("tv_id = ?", id).
        where("season_number = ?", season_number).
        where("role = ?", "crew").map { |c| c.person_id }.uniq

        cast_people_ids = TvCredit.select("person_id").where("tv_id = ?", id).
        where("season_number = ?", season_number).
        where("role = ?", "cast").map { |c| c.person_id }.uniq

        @tv = Tv.find(id)
        @season_number = season_number
        @episode = tv_episodes
        @crew = Person.find(crew_people_ids)
        @cast = Person.find(cast_people_ids)
    end

    def get_episode
        id = params[:id]
        season_number = params[:season_number]
        episode_number = params[:episode_number]

        episode = TvEpisode.where("tv_id = ?", id).
        where("season_number = ?", season_number).
        where("episode_number = ?", episode_number).first


        crew_people_ids = TvCredit.select("person_id").where("tv_id = ?", id).
        where("season_number = ?", season_number).
        where("episode_number =?", episode_number).
        where("role = ?", "crew").map { |c| c.person_id }

        cast_people_ids = TvCredit.select("person_id").where("tv_id = ?", id).
        where("season_number = ?", season_number).
        where("episode_number =?", episode_number).
        where("role = ?", "cast").map { |c| c.person_id }

        @tv = Tv.find(id)
        @episode = episode
        @crew = Person.find(crew_people_ids)
        @cast = Person.find(cast_people_ids)
    end
  end