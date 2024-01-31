class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade, on_update: :cascade }
      t.text :activity
      t.timestamps
    end
  end
end
