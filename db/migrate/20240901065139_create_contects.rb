class CreateContects < ActiveRecord::Migration[7.0]
  def change
    create_table :contects do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :message
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
