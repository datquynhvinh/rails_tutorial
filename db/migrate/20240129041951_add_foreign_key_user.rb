class AddForeignKeyUser < ActiveRecord::Migration[7.1]
  def change
    def change
      add_reference :microposts, :user, foreign_key: true, on_delete: :cascade, on_update: :cascade
    end
  end
end
