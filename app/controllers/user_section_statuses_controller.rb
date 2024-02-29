class UserSectionStatusesController < ApplicationController
  before_action :logged_in_user

  def update
    section_id = params[:section_id]

    @course = Course.find_by(id: params[:course_id])
    return unless valid_resource?(@course)

    @section = Section.find_by(id: section_id)
    return unless valid_resource?(@section)

    @lesson = Lesson.find_by(id: params[:lesson_id])
    return unless valid_resource?(@lesson)

    @user_section_status = UserSectionStatus.find_or_create_by(user_id: current_user.id, section_id: section_id)
    if @section.answer == params[:section][:answer]
      @user_section_status.update(completed_at: DateTime.now, status: 1)
      flash[:success] = "Answer correct! Answer is #{@section.answer}"
    else
      flash[:danger] = "Answer not correct! Answer is #{@section.answer}"
    end

    @sections_unfinished = @lesson.sections
                                  .joins("LEFT JOIN user_section_statuses ON user_section_statuses.section_id = sections.id AND user_section_statuses.user_id = #{current_user.id}")
                                  .select("sections.*, COALESCE(user_section_statuses.status, 0) AS status")
                                  .where('user_section_statuses.status = 0')
    if @sections_unfinished.empty?
      Activity.create(user_id: current_user.id, activity: "#{current_user.name} completed course #{@course.name} - lesson #{@lesson.name}")
    end

    redirect_back(fallback_location: root_path)
  end
end
