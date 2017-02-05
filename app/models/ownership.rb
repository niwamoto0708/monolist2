class Ownership < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :item, class_name: "Item"
  
  def self.top10
    hash = group(:item_id).order('count_item_id desc').limit(10).count(:item_id) # { item_id: 数 }
    item_ids = hash.keys # [item_id, item_id]
    items = Item.find(item_ids)
    items.sort_by{ |item| item_ids.index(item.id) }
  end
end
