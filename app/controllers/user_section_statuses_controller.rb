class UserSectionStatusesController < ApplicationController
  def update
    # @user_section_status = UserSectionStatus.fin
    @section = Section.find_by(id: params[:section_id])
    return unless valid_resource?(@section)

    @user_section_status = UserSectionStatus.find_or_create_by(user_id: params[:user_id], section_id: params[:section_id])
    if @section.answer == params[:section][:answer]
      @user_section_status.update(completed_at: DateTime.now, status: 1)
      flash[:success] = "Answer correct!"
    else
      flash[:danger] = "Answer not correct!"
    end

    redirect_back(fallback_location: root_path)
  end
end
