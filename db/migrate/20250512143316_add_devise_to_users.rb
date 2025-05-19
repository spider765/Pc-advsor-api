# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[8.0]
  def up
    change_table :users do |t|
      # Only add email if it doesn't exist
      unless column_exists?(:users, :email)
        t.string :email, null: false, default: ""
      end

      # Do the same for other columns
      unless column_exists?(:users, :encrypted_password)
        t.string :encrypted_password, null: false, default: ""
      end

      # Add other Devise columns similarly
    end

    # Only add indexes if they don't exist
    unless index_exists?(:users, :email, unique: true)
      add_index :users, :email, unique: true
    end
  end





  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
