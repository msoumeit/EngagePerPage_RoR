class BusinessesConnects < ActiveRecord::Migration
   def change
    create_table :businesses_connects do |t|
           t.integer :business_id
           t.integer :connect_id
    end
  end
end
