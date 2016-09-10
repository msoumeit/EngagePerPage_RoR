class CreateConnects < ActiveRecord::Migration
  def change
    create_table :connects do |t|
      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret
      t.integer :expires_at
      t.string :name

      t.timestamps
    end
  end
end
