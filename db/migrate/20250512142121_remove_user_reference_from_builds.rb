class RemoveUserReferenceFromBuilds < ActiveRecord::Migration[8.0]

    def change
      # First remove the index if it exists
      if index_exists?(:builds, :user_id, name: "index_builds_on_user_id")
        remove_index :builds, name: "index_builds_on_user_id"
      end

      # Then remove the column
      remove_column :builds, :user_id, :bigint
    end
  end
