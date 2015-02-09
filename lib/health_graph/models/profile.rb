module HealthGraph
  class Profile
    include Model              
    
    hash_attr_accessor :location, :name, :gender, :athlete_type, :profile
    
    def initialize(access_token, path)            
      self.access_token = access_token
      response = get path, HealthGraph.accept_headers[:profile]
      if response.body.reason
        raise response.body.reason
      end
      self.body = response.body
      populate_from_hash! self.body
    end                   
    
    def elite?
      self.body["elite"] == "true"
    end
  end
end