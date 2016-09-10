class AddSecretToSocials < ActiveRecord::Migration
  def change
     add_column :socials , :secret , :string
     remove_column :socials ,:refresh_token , :string
  end
end
