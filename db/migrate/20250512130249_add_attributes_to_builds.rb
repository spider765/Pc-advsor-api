class AddAttributesToBuilds < ActiveRecord::Migration[8.0]
  def change
    add_column :builds, :cpu, :string
    add_column :builds, :gpu, :string
    add_column :builds, :ram, :string
    add_column :builds, :storage, :string
    add_column :builds, :motherboard, :string
  end
end
