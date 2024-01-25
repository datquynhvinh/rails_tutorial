class Admin::BaseController < ApplicationController
  before_action :require_admin

  private
    def require_admin
      unless current_user
        store_location_for(:user, request.fullpath) if request.get?
        redirect_to new_user_session_path
        return
      end

      @user = current_user
      stored_location = stored_location_for(current_user)
      redirect_to stored_location || root_path, alert: 'Access denied.' unless current_user.is_admin?
    end
end
