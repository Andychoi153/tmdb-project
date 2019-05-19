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

ARGV.each do|movie_id|
    # movie
    tmdb_uri = URI("https://api.themoviedb.org/3/movie/#{movie_id}?api_key=#{api_key}")
    local_uri = URI("http://localhost:3000/movie/info")

    # TMDB api 에서 크롤 한 뒤
    params = get(tmdb_uri)
    status = params['status_code']
    if status.nil?
        # 크롤 된 parameter 를 post body로 넣을 parameter 에 match
        body = {'movie_id'=>movie_id,
                'title'=>params['title'],
                'poster_path'=>params['poster_path'],
                'vote_average'=>params['vote_average'],
                'vote_count'=>params['vote_count']}
        # local server 에 등록
        response = post(local_uri, body)

        # movie credit (crew, cast) & person 등록
        tmdb_uri = URI("https://api.themoviedb.org/3/movie/#{movie_id}/credits?api_key=#{api_key}")
        local_uri_credit = URI("http://localhost:3000/movie/credit")
        local_uri_person = URI("http://localhost:3000/person/info")
        params = get(tmdb_uri)
        params['crew'].each do |crew|
            # schema relation 고려, person 먼저 넣고
            person_body = {'person_id'=>crew['id'],
                'name'=>crew['name'],
                'profile_path'=>crew['profile_path']}
            response = post(local_uri_person, person_body)
            puts response

            # movie 넣기
            credit_body = {'movie_id'=>movie_id,
                        'person_id'=>crew['id'],
                        'role'=>'crew'}
            response = post(local_uri_credit, credit_body)
            puts response

        end

        params['cast'].each do |cast|
            person_body = {'person_id'=>cast['id'],
                'name'=>cast['name'],
                'profile_path'=>cast['profile_path']}
            response = post(local_uri_person, person_body)
            puts response

            credit_body = {'movie_id'=>movie_id,
                        'person_id'=>cast['id'],
                        'role'=>'cast'}
            response = post(local_uri_credit, credit_body)
            puts response

        end
    else
        puts params
    end
end
