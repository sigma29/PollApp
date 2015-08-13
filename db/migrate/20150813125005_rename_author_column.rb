class RenameAuthorColumn < ActiveRecord::Migration
  def change
    remove_column :polls, :author, :string
    add_column :polls, :author_id, :integer
  end
end
