class ChangeDataTypeToPost < ActiveRecord::Migration
  def change
    change_column :posts, :message, :text
  end
end
