class CreateUserSectionStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :user_section_statuses do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade, on_update: :cascade }
      t.references :section, null: false, foreign_key: { on_delete: :cascade, on_update: :cascade }
      t.integer :status, default: '0', comment: 'user section status 0: open, 1: process, 2: done.'
      t.date :completed_at
      t.timestamps
    end

    add_index :user_section_statuses, [:user_id, :section_id], unique: true
  end
end
