class CoursesController < ApplicationController
  before_action :logged_in_user

  def index
    @user_courses = UserCourse.where(user_id: current_user.id)
    @courses_search = Course.joins(:user_courses).where(user_courses: { id: @user_courses.map(&:id) }).ransack(name_cont: params[:search])
    @courses = @courses_search.result.paginate(page: params[:page], per_page: 6)
  end
end
