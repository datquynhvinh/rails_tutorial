class Admin::UserCoursesController < Admin::BaseController
  def show
    @user = User.find_by(id: params[:user_id])
    return unless valid_resource?(@user)

    @user_courses = UserCourse.where(user_id: params[:user_id])
    @courses_search = Course.joins(:user_courses).where(user_courses: { id: @user_courses.map(&:id) }).ransack(name_cont: params[:search])
    @courses = @courses_search.result.paginate(page: params[:page], per_page: 6)
  end

  def lessons
    @user = User.find_by(id: params[:user_id])
    return unless valid_resource?(@user)

    @user_courses = UserCourse.where(user_id: params[:user_id], course_id: params[:course_id])
    return unless valid_resource?(@user_courses)

    @course = Course.find_by(id: params[:course_id])
    return unless valid_resource?(@course)

    @lessons_search = @course.lessons.ransack(name_cont: params[:search])
    @lessons = @lessons_search.result.paginate(page: params[:page], per_page: 3)

    @lessons_with_completion = {}
    @lessons.each do |lesson|
      sections = lesson.sections
                       .joins("LEFT JOIN user_section_statuses ON user_section_statuses.section_id = sections.id AND user_section_statuses.user_id = #{params[:user_id]}")
                       .select("sections.*, COALESCE(user_section_statuses.status, 0) AS status")

      total_sections = sections.length
      count_complete = sections.count { |section| section.status == 1 }
      completion_percentage = total_sections.zero? ? 0 : (count_complete.to_f / total_sections) * 100
      @lessons_with_completion[lesson.id] = completion_percentage
    end
  end

  def sections
    @user = User.find_by(id: params[:user_id])
    return unless valid_resource?(@user)

    @course = Course.find_by(id: params[:course_id])
    return unless valid_resource?(@course)

    @lesson = Lesson.find_by(id: params[:lesson_id])
    return unless valid_resource?(@course)

    sections = Section.joins(lesson: { course: { user_courses: :user } })
                 .joins('LEFT JOIN user_section_statuses ON user_section_statuses.user_id = users.id AND user_section_statuses.section_id = sections.id')
                 .where(users: { id: params[:user_id] },
                             courses: { id: params[:course_id] },
                             lessons: { id: params[:lesson_id] })
                      .select('sections.*, COALESCE(user_section_statuses.status, 0) AS status')
                      .ransack(name_cont: params[:search])
    @sections = sections.result.paginate(page: params[:page], per_page: 3)
  end
end
