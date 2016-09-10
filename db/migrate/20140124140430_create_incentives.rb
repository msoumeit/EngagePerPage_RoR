class CreateIncentives < ActiveRecord::Migration
  def change
    create_table :incentives do |t|
      t.string :title
      t.string :code
      t.integer :owner_id
      t.integer :player_id
      t.string :expirydate
      t.string :assigndate
      t.string :type
      t.timestamps
    end
  end
end
