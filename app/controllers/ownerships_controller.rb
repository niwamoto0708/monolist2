class OwnershipsController < ApplicationController
  before_action :logged_in_user

  def create
    if params[:item_code]
      @item = Item.find_or_initialize_by(item_code: params[:item_code])
    else
      @item = Item.find(params[:item_id])
    end

    # itemsテーブルに存在しない場合は楽天のデータを登録する。
    if @item.new_record?
      # TODO 商品情報の取得 RakutenWebService::Ichiba::Item.search を用いてください
      items = RakutenWebService::Ichiba::Item.search(itemCode: @item.item_code)
      # Item.each do |item|
      
      item                  = items.first
      @item.title           = item['itemName']
      @item.small_image     = item['smallImageUrls'].first['imageUrl']
      @item.medium_image    = item['mediumImageUrls'].first['imageUrl']
      @item.large_image     = item['mediumImageUrls'].first['imageUrl'].gsub('?_ex=128x128', '')
      @item.detail_page_url = item['itemUrl']
      @item.save!
    end
    
    # TODO ユーザにwant or haveを設定する
    # params[:type]の値にHaveボタンが押された時には「Have」,
    # Wantボタンが押された時には「Want」が設定されています。
    
    if params[:type] == "Have"
    # @item = Item.find(params[:type])
      current_user.have(@item)
    elsif params[:type] == "Want"
      current_user.want(@item)
    end
  end
    
    # if @type = @item.find(params[:type])
    #   respond_to do |format|
    #   format.html
    #   format.js
    # end
    
    # if params[:type]
    #   @item = Item.find(ownerships_type: "Have")
    #   current_user.have(@item)
    # else
    #   current_user.unhave(@item)
    # end
    
    # if @item = Item.find(ownerships_type: "Want")
    #   current_user.want(@item)
    # else
    #   current_user.unwant(@item)
    # end
    
    # if params[:type] = "Have"
    #   <%= link_to 'items/have' %>
    #   render 'items/action'
    # else
    #   params[:type] = "Want"
    #   <%= link_to 'items/want' %>
    #   render 'items/action'
    # end

  def destroy
    @item = Item.find(params[:item_id])

    # TODO 紐付けの解除。 
    # params[:type]の値にHave itボタンが押された時には「Have」,
    # Want itボタンが押された時には「Want」が設定されています。
    
    if params[:type] == "Have"
    # @item = Item.find(params[:type])
    # @item = current_user.ownerships_type.find(params[:type]).have
      current_user.unhave(@item)
    elsif params[:type] == "Want"
      current_user.unwant(@item)
    end
  end
    # if @type = @item.find(params[:type])
    #   respond_to do |type|
    #   type.html
    #   type.js
    # end
    
    # if @item = Item.find(ownerships_type: "Unhave")
    #   current_user.unhave(@item)
    # else
    #   current_user.have(@item)
    # end
    
    # if @item = Item.find(ownerships_type: "Unwant")
    #   current_user.unwant(@item)
    # else
    #   current_user.want(@item)
    # end
    
    # if params[:type] = "Have it"
    #   <%= link_to 'items/unhave' %>
    #   render 'items/action'
    # else
    #   params[:type] = "Want it"
    #   <%= link_to 'items/unwant' %>
    #   render 'items/action'
end