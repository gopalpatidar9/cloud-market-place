class CreateFeatures < ActiveRecord::Migration[7.0]
  def change
    create_table :features do |t|
      t.references :service, null: false, foreign_key: true
      t.string :feature_name
      t.string :feature_value

      t.timestamps
    end
  end
end
