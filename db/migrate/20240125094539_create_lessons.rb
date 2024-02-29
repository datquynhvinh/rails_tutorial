class CreateLessons < ActiveRecord::Migration[7.1]
  def change
    create_table :lessons do |t|
      t.references :course, null: false, foreign_key: true, on_delete: :cascade, on_update: :cascade
      t.text :name
      t.timestamps
    end
  end
end
