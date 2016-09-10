class Pictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.column :title, :string
    end
  end
end
