class ApplicationController < ActionController::Base
    
    # 일단 standard error(db error) 만 execption json 형식으로 render
    protect_from_forgery with: :exception
    include Error::ErrorHandler
end
