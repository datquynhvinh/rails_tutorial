class CeateMicroposts < ActiveRecord::Migration[7.1]
  def change
    create_table :microposts do |t|
      t.text :content
      t.bigint :user_id

      t.timestamps
    end
    add_foreign_key :microposts, :users, :column=>:user_id, :on_delete=>:cascade, :on_update=>:cascade
  end
end
