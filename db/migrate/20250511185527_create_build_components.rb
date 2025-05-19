class CreateBuildComponents < ActiveRecord::Migration[8.0]
  def change
    create_table :build_components do |t|
      t.references :build, null: false, foreign_key: true
      t.references :component, null: false, foreign_key: true

      t.timestamps
    end
  end
end
