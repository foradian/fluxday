module Api::V1
  class CredentialsController < ApiController
    respond_to :html, :xml, :json
    skip_before_filter :authenticate_user!, :only=>[:me]
    doorkeeper_for :all

    #respond_to :json

    def me
      if current_resource_owner
        respond_with current_resource_owner
      else
        error = { :error => "Invalid grant." }
        respond_with error
      end
    end


  end
end

