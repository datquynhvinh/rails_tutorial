class AddSectionQuestion < ActiveRecord::Migration[7.1]
  def change
    add_column :sections, :question, :text
    add_column :sections, :answer, :string
  end
end
