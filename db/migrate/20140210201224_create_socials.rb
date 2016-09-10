class CreateSocials < ActiveRecord::Migration
  def change
    create_table :socials do |t|
      t.string :provider
      t.string :uid
      t.string :token
      t.string :refresh_token
      t.integer :expires_at
      t.string :name

      t.timestamps
    end
  end
end
