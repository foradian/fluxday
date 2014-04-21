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
      user = OauthApplication.find(doorkeeper_token.try(&:application_id)).users.find(doorkeeper_token.try(&:resource_owner_id))
    end

  end
end


