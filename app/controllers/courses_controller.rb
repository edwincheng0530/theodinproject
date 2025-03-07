class CoursesController < ApplicationController
  def show
    @path = Path.find(params[:path_id])
    @course = @path.courses.friendly.find(params[:id])
    @sections = @course.sections.includes(:lessons)

    mark_completed_lessons
  end

  private

  def mark_completed_lessons
    return if current_user.nil?

    Courses::MarkCompletedLessons.call(
      user: current_user,
      lessons: @sections.flat_map(&:lessons)
    )
  end
end
