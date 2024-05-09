class CreateInfluencers < ActiveRecord::Migration[4.2]
  def change
    create_table :influencers do |t|
      t.bigint :user_id, references: :users, index: true
      t.integer :scout_status, default: 10, comment: "スカウト状況"
      t.integer :partner_status, default: 10, comment: "発注ステータス"

      t.timestamps null: false
    end
    add_foreign_key :influencers, :users
    add_index :influencers, :user_id, name: 'user_id_2', unique: true
    add_index :influencers, :user_id, name: 'user_id', unique: true
  end
end

