class CreateUserCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :user_courses do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade, on_update: :cascade }
      t.references :course, null: false, foreign_key: { on_delete: :cascade, on_update: :cascade }
      t.date :enrolled_date
      t.timestamps
    end

    add_index :user_courses, [:user_id, :course_id], unique: true
  end
end
