require 'httparty'
require 'json'

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

  def get_me
    response = self.class.get('/users/me', headers: { 'authorization' => @auth_token })
    raise 'Invalid Auth Token' unless response.code == 200
    parsed_response = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    mentor_url = '/mentors/' << mentor_id.to_s << '/student_availability'
    response = self.class.get(mentor_url, headers: { 'authorization' => @auth_token })
    parsed_response = JSON.parse(response.body)
  end
end
