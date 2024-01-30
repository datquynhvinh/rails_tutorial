class CreateSections < ActiveRecord::Migration[7.1]
  def change
    create_table :sections do |t|
      t.references :lesson, null: false, foreign_key: { on_delete: :cascade, on_update: :cascade }
      t.text :name
      t.timestamps
    end
  end
end
