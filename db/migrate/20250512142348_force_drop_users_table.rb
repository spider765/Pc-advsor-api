class ForceDropUsersTable < ActiveRecord::Migration[8.0]
  def up
    execute "DROP TABLE IF EXISTS users CASCADE"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
