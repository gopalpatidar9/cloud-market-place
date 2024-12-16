class CreateComparisons < ActiveRecord::Migration[7.0]
  def change
    create_table :comparisons do |t|
      t.references :predefined_requirement, null: false, foreign_key: true
      t.references :cloud_platform, null: false, foreign_key: true
      t.integer :score
      t.text :description

      t.timestamps
    end
  end
end
