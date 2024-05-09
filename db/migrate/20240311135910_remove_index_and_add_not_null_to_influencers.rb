class RemoveIndexAndAddNotNullToInfluencers < ActiveRecord::Migration[7.1]
  def change
    change_column :influencers, :scout_status, :integer, default: 10, null: false
    change_column :influencers, :partner_status, :integer, default: 10, null: false

    remove_index :influencers, name: 'index_influencers_on_user_id'
    remove_index :influencers, name: 'user_id_2'
  end
end
