require 'httparty'
class Facebook
  include HTTParty
  
  base_uri 'https://graph.facebook.com'
  format :json
  
  @facebook_app_id = FB_APP_ID
  @facebook_secret_id = FB_SECRET_ID
  
  def self.getToken(code, redirect_url)
    response = get('/oauth/access_token', :query => { :client_id => Facebook.facebook_app_id, :redirect_uri => redirect_url, :client_secret => Facebook.facebook_secret_id, :code => code })
    resArray = CGI.parse(response)
    return resArray["access_token"][0]
  end
  
  def self.getUserInfo(token)
    #encToken = CGI::escape(token)
    get('/me', :query => { :access_token => token })
    #get('/me?access_token=' + token)
  end
  
  def self.getOAuthURL(redirectURL)
    scope = 'publish_stream,offline_access,email'
    url = base_uri + '/oauth/authorize?client_id=' + Facebook.facebook_app_id + '&redirect_uri=' + redirectURL + '&scope=' + scope
    return url
  end
  
  def self.updateStatus(user_id, token, message)
	response = post('/' + user_id +'/feed', :query => {:access_token => token, :message => message})
	return response
  end
  
  def self.facebook_app_id
    @facebook_app_id
  end
  
  def self.facebook_secret_id
    @facebook_secret_id
  end
end