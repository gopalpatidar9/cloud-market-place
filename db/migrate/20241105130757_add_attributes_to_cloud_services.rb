class AddAttributesToCloudServices < ActiveRecord::Migration[7.0]
  def change
    add_column :cloud_services, :user_capacity, :integer
    add_column :cloud_services, :supports_sql, :boolean
    add_column :cloud_services, :supports_nosql, :boolean
    add_column :cloud_services, :managed_service, :boolean
  end
end
