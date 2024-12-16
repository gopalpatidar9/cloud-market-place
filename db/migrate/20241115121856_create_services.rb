class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.references :provider, null: false, foreign_key: true
      t.string :service_type
      t.string :service_name
      t.decimal :price_per_month
      t.string :security_level
      t.text :description

      t.timestamps
    end
  end
end
