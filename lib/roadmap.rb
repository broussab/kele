module Roadmaps
  def get_roadmap(roadmap_id)
    roadmap_url = '/roadmaps/' << roadmap_id.to_s
    response = self.class.get(roadmap_url, headers: { 'authorization' => @auth_token })
    parsed_response = JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    checkpoint_url = '/checkpoints/' << checkpoint_id.to_s
    response = self.class.get(checkpoint_url, headers: { 'authorization' => @auth_token })
    parsed_response = JSON.parse(response.body)
  end
end
