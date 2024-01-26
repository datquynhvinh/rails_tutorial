class CreateLessons < ActiveRecord::Migration[7.1]
  def change
    create_table :lessons do |t|
      t.references :course, null: false, foreign_key: true
      t.text :name
      t.timestamps
    end
  end
end
