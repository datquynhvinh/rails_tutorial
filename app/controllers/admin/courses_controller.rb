class Admin::CoursesController < Admin::BaseController
  def index
    @courses_search = Course.ransack(name_cont: params[:search])
    @courses = @courses_search.result.paginate(page: params[:page], per_page: 10)
  end

  def show
    @course = Course.find_by(id: params[:id])
    return unless valid_resource?(@course)
    @lessons_search = @course.lessons.ransack(name_cont: params[:search])
    @lessons = @lessons_search.result.paginate(page: params[:page], per_page: 5)
  end

  def new
    @course = Course.new
  end
end
