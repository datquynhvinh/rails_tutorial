class SectionsController < ApplicationController
  def index
    @course = Course.find_by(id: params[:course_id])
    return unless valid_resource?(@course)

    @lesson = Lesson.find_by(id: params[:lesson_id])
    return unless valid_resource?(@lesson)

    sections = Section.joins(lesson: { course: { user_courses: :user } })
                      .joins('LEFT JOIN user_section_statuses ON user_section_statuses.user_id = users.id AND user_section_statuses.section_id = sections.id')
                      .where(users: { id: current_user.id },
                             courses: { id: params[:course_id] },
                             lessons: { id: params[:lesson_id] })
                      .select('sections.*, COALESCE(user_section_statuses.status, 0) AS status')
                      .ransack(name_cont: params[:search])
    @sections = sections.result.paginate(page: params[:page], per_page: 3)
  end
end
