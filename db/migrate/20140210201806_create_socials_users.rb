class CreateSocialsUsers < ActiveRecord::Migration
  def change
    create_table :socials_users do |t|
           t.integer :social_id
           t.integer :user_id
    end
  end
end
