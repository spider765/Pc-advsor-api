class CreateBuilds < ActiveRecord::Migration[8.0]
  def change
    create_table :builds do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.decimal :total_price

      t.timestamps
    end
  end
end
