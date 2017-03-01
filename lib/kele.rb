require 'httparty'

class Kele
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1/'

  def initialize(email, pass)
    user_creds = {
      body: {
        email:  email,
        password: pass
      }
    }
    response = self.class.post('/sessions', user_creds)
    raise 'Invalid Credentials' unless response.code == 200
    @auth_token = response['auth_token']
  end
end
