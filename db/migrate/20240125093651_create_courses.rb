class CreateCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :courses do |t|
      t.text :name
      t.timestamps
    end
  end
end
