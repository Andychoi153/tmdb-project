# Refactored ErrorHandler to handle multiple errors
# Rescue StandardError acts as a Fallback mechanism to handle any exception
# https://medium.com/rails-ember-beyond/error-handling-in-rails-the-modular-way-9afcddd2fe1b 참조
module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        # 일단 standard error 만 처리
        # 대부분 standard error 는 db duplicate entry 문제임, status 500 대신 504
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