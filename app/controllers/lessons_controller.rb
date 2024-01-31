class LessonsController < ApplicationController
  def index
    @user_courses = UserCourse.where(user_id: current_user.id, course_id: params[:course_id])
    return unless valid_resource?(@user_courses)

    @course = Course.find_by(id: params[:course_id])
    return unless valid_resource?(@course)

    @lessons_search = @course.lessons.ransack(name_cont: params[:search])
    @lessons = @lessons_search.result.paginate(page: params[:page], per_page: 3)

    @lessons_with_completion = {}
    @lessons.each do |lesson|
      sections = lesson.sections
                       .joins("LEFT JOIN user_section_statuses ON user_section_statuses.section_id = sections.id AND user_section_statuses.user_id = #{current_user.id}")
                       .select("sections.*, COALESCE(user_section_statuses.status, 0) AS status")

      total_sections = sections.length
      count_complete = sections.count { |section| section.status == 1 }
      completion_percentage = total_sections.zero? ? 0 : (count_complete.to_f / total_sections) * 100
      @lessons_with_completion[lesson.id] = completion_percentage
    end
  end
end
