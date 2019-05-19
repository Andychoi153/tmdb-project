#!/usr/bin/env ruby
api_key = "여기에 api key 넣기"
require 'uri'
require 'net/http'
require 'openssl'
require 'json'

def get(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri)
    request.body = "{}"

    response = http.request(request)
    params = response.read_body
    params = JSON.parse(params)
end

def post(uri, body)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
    request.body = body.to_json

    response = http.request(request)
    response.body
end

ARGV.each do|tv_id|
    # tv
    tmdb_uri = URI("https://api.themoviedb.org/3/tv/#{tv_id}?api_key=#{api_key}")
    local_uri = URI("http://localhost:3000/tv/info")
    local_uri_credit = URI("http://localhost:3000/tv/credit")
    local_uri_person = URI("http://localhost:3000/person/info")

    tmdb_credit_uri = URI("https://api.themoviedb.org/3/tv/#{tv_id}/credits?api_key=#{api_key}")


    params = get(tmdb_uri)
    status = params['status_code']
    if status.nil?
        body = {'tv_id'=>tv_id,
                'name'=>params['name'],
                'poster_path'=>params['poster_path'],
                'vote_average'=>params['vote_average'],
                'vote_count'=>params['vote_count']}
        response = post(local_uri, body)
        puts response

        credit_params = get(tmdb_credit_uri)

        credit_params['crew'].each do |crew|
            # schema relation 고려, person 먼저 넣고
            person_body = {'person_id'=>crew['id'],
                'name'=>crew['name'],
                'profile_path'=>crew['profile_path']}
            response = post(local_uri_person, person_body)
            puts response

            # movie 넣기
            credit_body = {'tv_id'=>tv_id,
                        'person_id'=>crew['id'],
                        'role'=>'crew'}
            response = post(local_uri_credit, credit_body)
            puts response

        end

        credit_params['cast'].each do |cast|
            person_body = {'person_id'=>cast['id'],
                'name'=>cast['name'],
                'profile_path'=>cast['profile_path']}
            response = post(local_uri_person, person_body)
            puts response

            credit_body = {'movie_id'=>tv_id,
                        'person_id'=>cast['id'],
                        'role'=>'cast'}
            response = post(local_uri_credit, credit_body)
            puts response

        end

        # tv season
        # season number 꺼내서 서버 post 적재
        # season api 활용하여, episode crawl loop 돌면서 episode, episode credit 적재
        params['seasons'].each do |season|
            season_number = season['season_number']

            tmdb_season_uri = URI("https://api.themoviedb.org/3/tv/#{tv_id}/season/#{season_number}?api_key=#{api_key}")
            local_season_uri = URI("http://localhost:3000/tv/season")
            local_season_credit_uri = URI("http://localhost:3000/tv/credit/season")
            local_episode_credit_uri = URI("http://localhost:3000/tv/credit/episode")
            local_episode_uri = URI("http://localhost:3000/tv/episode")


            params = get(tmdb_season_uri)

            # season 정보 넣어주고
            body = {'tv_id'=>tv_id,
                    'season_number'=>season_number,
                    'poster_path'=>params['poster_path']}
            
            response = post(local_season_uri, body)
            puts response

            episodes = params['episodes']
            episodes.each do |episode|
                # episode 정보 넣어주고
                episode_number = episode['episode_number']

                body = {'tv_id'=>tv_id,
                        'season_number'=>season_number,
                        'episode_number'=>episode_number,
                        'still_path'=>episode['still_path'],
                        'vote_average'=>episode['vote_average'],
                        'vote_count'=>episode['vote_count']}
                response = post(local_episode_uri, body)
                
                episode['crew'].each do |crew|
                    # person 넣어주고
                    person_body = {'person_id'=>crew['id'],
                                    'name'=>crew['name'],
                                    'profile_path'=>crew['profile_path']}
                    response = post(local_uri_person, person_body)
                    puts response

                    # episode credit 넣어주고
                    credit_body = {'tv_id'=>tv_id,
                        'person_id'=>crew['id'],
                        'season_number'=>season_number,
                        'episode_number'=>episode_number,
                        'role'=>'crew'}
                    response = post(local_uri_credit, credit_body)
                    puts response
                end
                
                episode['guest_stars'].each do |cast|
                    # person 넣어주고
                    person_body = {'person_id'=>cast['id'],
                        'name'=>cast['name'],
                        'profile_path'=>cast['profile_path']}
                    response = post(local_uri_person, person_body)
                    puts response

                    # episode credit 넣어주고
                    credit_body = {'tv_id'=>tv_id,
                        'person_id'=>cast['id'],
                        'season_number'=>season_number,
                        'episode_number'=>episode_number,
                        'role'=>'cast'}
                    response = post(local_uri_credit, credit_body)
                    puts response
                end
            end
        end
    else
        puts params
    end
end
