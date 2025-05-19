class CreateComponents < ActiveRecord::Migration[8.0]
  def change
    create_table :components do |t|
      t.string :name
      t.string :category
      t.string :brand
      t.decimal :price
      t.jsonb :specs

      t.timestamps
    end
  end
end
