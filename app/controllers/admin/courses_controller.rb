class Admin::CoursesController < Admin::BaseController
  def index
    @courses = Course.paginate(page: params[:page], per_page: 10)
  end

  def show
    @course = Course.find_by(id: params[:id])
  end
end
