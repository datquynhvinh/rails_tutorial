class AddCouseImage < ActiveRecord::Migration[7.1]
  def change
    add_column :courses, :image, :string, after: :name
  end
end
