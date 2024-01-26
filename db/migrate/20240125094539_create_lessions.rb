class CreateLessions < ActiveRecord::Migration[7.1]
  def change
    create_table :lessions do |t|
      t.references :courses, null: false, foreign_key: true
      t.text :name
      t.timestamps
    end
  end
end
