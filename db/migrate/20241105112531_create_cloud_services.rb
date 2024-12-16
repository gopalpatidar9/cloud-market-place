class CreateCloudServices < ActiveRecord::Migration[7.0]
  def change
    create_table :cloud_services do |t|
      t.string :name
      t.string :provider
      t.decimal :pricing
      t.text :features

      t.timestamps
    end
  end
end
