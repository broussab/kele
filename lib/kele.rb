require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmaps
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

  def get_messages(*page)
    if page.empty?
      response = self.class.get('/message_threads/', headers: { 'authorization' => @auth_token })
    else
      response = self.class.get('/message_threads/', values: { 'page' => page[0] }, headers: { 'authorization' => @auth_token })
    end
    parsed_response = JSON.parse(response.body)
  end

  def create_message(sender, recipient_id, token, subject, text)
    message_values = {
      my_body: {
        sender: sender.to_s,
        recipient_id: recipient_id.to_i,
        token: token.to_s,
        subject: subject.to_s,
        stripped_text: text.to_s
      }
    }
    response = self.class.post('https://private-anon-b99b0892a6-blocapi.apiary-mock.com/api/v1/messages', values: message_values, headers: { 'authorization' => @auth_token })
    raise 'Invalid Message' unless response.code == 200
    puts 'Message successfully posted!' if response.code == 200
  end
end
