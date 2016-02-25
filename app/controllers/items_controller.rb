class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
    @items = Item.paginate(page: params[:page], per_page: 20).where(published: true)
  end

  def new
    @item = Item.new
  end

  def show
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    @item.published = true

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render action: 'show', status: :created, location: @item }
      else
        format.html { render action: 'new' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @item.published = false
    @item.save

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end

  def search
    @items =  Item.all.where('name ILIKE ?', "%#{params[:search][:item_name]}%")
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
      @categories = ItemCategory.find(:all)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:image_url,
                                   :sku,
                                   :name,
                                   :description,
                                   :price,
                                   :stock_amount,
                                   :cost_price,
                                   :item_category_id,
                                   :published)
    end
end
