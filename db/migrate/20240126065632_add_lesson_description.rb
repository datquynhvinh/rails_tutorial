class AddLessonDescription < ActiveRecord::Migration[7.1]
  def change
    add_column :lessons, :description, :string, after: :name
  end
end
