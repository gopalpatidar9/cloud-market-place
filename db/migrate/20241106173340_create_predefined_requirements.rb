class CreatePredefinedRequirements < ActiveRecord::Migration[7.0]
  def change
    create_table :predefined_requirements do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
