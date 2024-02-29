class CreateLessons < ActiveRecord::Migration[7.1]
  def change
    create_table :lessons do |t|
      t.bigint :course_id
      t.text :name
      t.timestamps
    end
    add_foreign_key :lessons, :courses, :column=>:course_id, :on_delete=>:cascade, :on_update=>:cascade
  end
end
