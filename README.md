README
======


Version
-------
  * ruby==2.5.3
  * rails==5.2.3
  * bundle==2.0.1

Database 
-------
* Create & Initialization
```
  $ rails db:create 
  $ rails db:migrate
```

* Database schema
![Alt text](/erd.png)
  * movie, person, tv, tv_season, tv_episode 는 메타 정보를 들고있음
    * role: cast/crew, person 이 담당한 역할
    * poster_path / profile_path: 해당 tv, movie/ person 이미지 정보
  * movie_credit, tv_credit의 경우는 각 movie, tv, tv_season, tv_episode 와 person 간 의 relation 정보를 들고있음
  * references by multiple key(index)에 대한 작업이 미진행, 이 때문에 ERD 에서는 tv_season, tv_episode 와 person 간의 relation 이 드러나지 않음
     * **[ tv_id, season_number ]** , **[ tv_id, season_number, episode_number ]** 를 index 로 만들어 tv_credit 의 foreign key로 설정한 뒤, tv_season, tv_episode 과 person 간 의 relation 을 구축하려고 했으나, 이해 부족으로 아직 미진행
    

Services process
----
![Alt text](/tmdb_insert&view_process.png)


* Deployment instructions
  * rails 서버 실행
    * **crawler 실행 이전에 반드시 서버는 켜져 있어야 합니다**
  ```
  $ rails server
  ```
    * **크롤러 돌리기 전에 lib/crawl_tv.rb , lib/crawl_movie.rb에 api key 삽입**
  ```
    #!/usr/bin/env ruby
    api_key = "여기에 api key 넣기"
    require 'uri'
    require 'net/http'
    require 'openssl'
    require 'json'
  ```
   * 단일 / 복수 개 insert 가능
  ```
  $ rails runner lib/crawl_tv.rb 1399
  $ rails runner lib/crawl_tv.rb 6 34

  $ rails runner lib/crawl_movie.rb 13
  $ rails runner lib/crawl_movie.rb 21 3
  ```


Convention
----

* Error handler
  * 일단 standard error 만 처리
  * 대부분 standard error 는 db duplicate entry 문제임
  * rails 에서 제공하는 debug view 대신 json 형식으로 status & message return
  * crawl script가 post 형식으로 server 에 db 넣으줄 값 입력, 해당 요청의  return 을 db insert 실패 발생시 원인 파악을 하기 위해서 htmls view 대신 간결한 json 으로 return

```
# /lib/error/error_handler
module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        # status 500 대신 504
        rescue_from StandardError do |e|
          respond(:standard_error, 504, e.to_s)
        end
      end
    end

    private
    
    def respond(_error, _status, _message)
      json = Helpers::Render.json(_error, _status, _message)
      render json: json
    end
  end
end
```

Issue
----
* TMDB API issue
  * 특정 tv / movie / person api 에서 누락된 정보가 들어오는 경우가 있음(상당히 많은 비율로..)
  * 아직 전부 다 파악은 못했으나, 하나의 예시로는  tv episode 별 crew / cast 가 누락되어 들어오는 경우가 있음
    * 일단 위 현상은 크롤러가 tmdb tv/, tv/episode api 에서 각각 가져온 정보로 두번 반복해서 people, tv_credits db에 정보를 채우도록 하는 것으로 대응
  * 향후 여러 케이스를 분석하여 정보의 무결성을 체크해야 할 것으로 보임