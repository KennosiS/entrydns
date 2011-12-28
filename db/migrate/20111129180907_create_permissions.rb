class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :domain # the domain to whom permission is being given
      t.references :user # the user permitted to manage

      t.timestamps
    end
    add_index :permissions, :domain_id
    add_index :permissions, :user_id
  end
end
