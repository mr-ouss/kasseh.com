class AddAdminToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :admin, :boolean, default: false, null: false
    add_index :users, :admin

    # Set primary admin account
    reversible do |dir|
      dir.up do
        User.find_by(email_address: User::PRIMARY_ADMIN_EMAIL)&.update_column(:admin, true)
      end
    end
  end
end
