class RelationshipsFk < ActiveRecord::Migration[7.1]
  def change
    change_column :relationships, :follower_id, :bigint
    change_column :relationships, :followed_id, :bigint

    add_foreign_key :relationships, :users, column: :follower_id, on_delete: :cascade, on_update: :cascade
    add_foreign_key :relationships, :users, column: :followed_id, on_delete: :cascade, on_update: :cascade
  end
end
