class AddStatusColumnToFriendship < ActiveRecord::Migration
  def change
    add_column :friendships, :status, :integer, dafault: 0
    add_column :friendships, :accepted_at, :datetime
    add_column :friendships, :removed_at, :datetime
    add_column :friendships, :removed_by, :integer
  end
end
