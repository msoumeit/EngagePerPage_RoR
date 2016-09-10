class AddRoleToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :role, :string , :default => "Business"
  end
end
