class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  before_filter :app_status
end

def app_status
  @app_status = "alpha"
end