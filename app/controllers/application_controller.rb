class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  # before_action :set_headers,:is_mobile?
  helper_method :is_mobile?,:is_bot_hit?

  # def set_headers
  #   expires_in 3.days, :public => true
  # end
  def is_bot_hit?
    user_agent = "User-Agent => #{request.env["HTTP_USER_AGENT"]}"
    Rails.logger.info  user_agent
    is_bot_hit =  user_agent.downcase.include?("bot") ? true : false
  end

  def is_mobile?
    mobile_devices =  ["android","ios","nokia","mobile","iphone","blackberry"]
    user_agent = request.headers["HTTP_USER_AGENT"]
    mobile_devices.each do |m|
      return true if user_agent =~  /#{m}/i
    end
    return false
  end


end
