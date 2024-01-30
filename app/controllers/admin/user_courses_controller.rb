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
  end

  def sections
    @user = User.find_by(id: params[:user_id])
    return unless valid_resource?(@user)

    @user_courses = UserCourse.where(user_id: params[:user_id], course_id: params[:course_id])
    return unless valid_resource?(@user_courses)

    @course = Course.find_by(id: params[:course_id])
    return unless valid_resource?(@course)

    @lesson = Lesson.find_by(id: params[:lesson_id])
    return unless valid_resource?(@course)

    @sections_search = @lesson.sections
                              .joins("LEFT OUTER JOIN user_section_statuses ON sections.id = user_section_statuses.section_id AND user_section_statuses.user_id = #{@user.id}")
                              .ransack(name_cont: params[:search])
    @sections = @sections_search.result.paginate(page: params[:page], per_page: 3)

  end
end
