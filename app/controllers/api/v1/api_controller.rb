module Api::V1
  class ApiController < ApplicationController


    #respond_to :json
    #
    #def explore
    #  @json = doorkeeper_access_token.get("api/v1/#{params[:api]}").parsed
    #  respond_with @json
    #end
    #
    #private
    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

  end
end


