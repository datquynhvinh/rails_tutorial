class Admin::UserCoursesController < Admin::BaseController
  def index
    @user = User.find_by(id: params[:user_id])
    return unless valid_resource?(@user)

    @user_courses = UserCourse.where(user_id: params[:user_id])
    @courses_search = Course.joins(:user_courses).where(user_courses: { id: @user_courses.map(&:id) }).ransack(name_cont: params[:search])
    @courses = @courses_search.result.paginate(page: params[:page], per_page: 6)
  end

  def lessons
    @user = User.find_by(id: params[:id])
    return unless valid_resource?(@user)

    @user_courses = UserCourse.where(user_id: params[:id], course_id: params[:course_id])
    return unless valid_resource?(@user_courses)

    @course = Course.find_by(id: params[:course_id])
    return unless valid_resource?(@course)

    @lessons_search = @course.lessons.ransack(name_cont: params[:search])
    @lessons = @lessons_search.result.paginate(page: params[:page], per_page: 3)

    @lessons_with_completion = {}
    @lessons.each do |lesson|
      sections = lesson.sections
                       .joins("LEFT JOIN user_section_statuses ON user_section_statuses.section_id = sections.id AND user_section_statuses.user_id = #{params[:id]}")
                       .select("sections.*, COALESCE(user_section_statuses.status, 0) AS status")

      total_sections = sections.length
      count_complete = sections.count { |section| section.status == 1 }
      completion_percentage = total_sections.zero? ? 0 : (count_complete.to_f / total_sections) * 100
      @lessons_with_completion[lesson.id] = completion_percentage
    end
  end

  def sections
    @user = User.find_by(id: params[:id])
    return unless valid_resource?(@user)

    @course = Course.find_by(id: params[:course_id])
    return unless valid_resource?(@course)

    @lesson = Lesson.find_by(id: params[:lesson_id])
    return unless valid_resource?(@course)

    sections = Section.joins(lesson: { course: { user_courses: :user } })
                 .joins('LEFT JOIN user_section_statuses ON user_section_statuses.user_id = users.id AND user_section_statuses.section_id = sections.id')
                 .where(users: { id: params[:id] },
                             courses: { id: params[:course_id] },
                             lessons: { id: params[:lesson_id] })
                      .select('sections.*, COALESCE(user_section_statuses.status, 0) AS status')
                      .ransack(name_cont: params[:search])
    @sections = sections.result.paginate(page: params[:page], per_page: 3)
  end

  def new
    user_id = params[:user_id]
    @user = User.find_by(id: user_id)
    return unless valid_resource?(@user)

    @user_course = UserCourse.new
    @courses = Course.joins("LEFT JOIN user_courses ON user_courses.course_id = courses.id AND user_courses.user_id = #{user_id}")
                     .select('courses.*, CASE WHEN enrolled_date IS NOT NULL THEN 1 ELSE 0 END AS enrolled')
  end

  def create
    user_id = params[:user_id]
    @enrolled_course_ids = UserCourse.where("user_id = #{user_id}").pluck(:course_id)
    cancel_course_ids = @enrolled_course_ids - params[:course_ids].map(&:to_i)
    unless cancel_course_ids.empty?
      UserCourse.where(user_id: user_id, course_id: cancel_course_ids).delete_all
    end

    new_course_ids = params[:course_ids].map(&:to_i) - @enrolled_course_ids
    unless new_course_ids.empty?
      enrollment_data = new_course_ids.map { |course_id| { user_id: user_id, course_id: course_id, enrolled_date: DateTime.now } }
      UserCourse.create(enrollment_data)
    end

    flash[:success] = "Updated!"
    redirect_to request.referrer || root_url
  end
end
