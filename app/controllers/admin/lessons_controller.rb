class Admin::LessonsController < Admin::BaseController
  def index
  end

  def show
  end

  def new
    @lesson = Lesson.new
    @courses = Course.all
  end

  def create
    @lesson = Lesson.new(lesson_params)
    if @lesson.save
      @courses = Course.find_by(id: @lesson.course_id)
      redirect_to admin_course_path(@courses)
    else
      @courses = Course.all
      render 'new'
    end
  end

  def edit
    @lesson = Lesson.find_by(id: params[:id])
    valid_resource?(@lesson)
    @courses = Course.all
  end

  def update
    @lesson = Lesson.find_by(id: params[:id])
    valid_resource?(@lesson)

    if !@lesson.nil? && @lesson.update(lesson_params)
      @course = Course.find_by(id: @lesson.course_id)
      redirect_to admin_course_path(@course), notice: 'Lesson was successfully updated.'
    else
      @courses = Course.all
      render 'edit'
    end
  end

  private
    def lesson_params
      params.require(:lesson).permit(:name, :description, :course_id)
    end
end
