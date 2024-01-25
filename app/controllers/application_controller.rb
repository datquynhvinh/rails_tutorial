class ApplicationController < ActionController::Base
    include SessionsHelper
    before_action :store_user_location!, if: :storable_location?

    private
        def logged_in_user
            unless logged_in?
                store_location
                flash[:danger] = "Please log in."
                redirect_to login_url
            end
        end

        def storable_location?
            request.get? && !request.xhr? && !devise_controller? && !request.path.start_with?('/admin')
        end

        def store_user_location!
            store_location_for(:user, request.fullpath)
        end
end
