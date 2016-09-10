class AddPromotionTitleAndPromotionUrlToTasks < ActiveRecord::Migration
  def change
    add_column :tasks , :promotion_title , :string
    add_column :tasks , :promotion_url , :string
  end
end
