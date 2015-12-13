# Controller for managing Cookbook record. Since frontend part is handled by
# AngularJS so no new and edit in actions.
class CookbooksController < ApplicationController
  before_action :prepare_rcd, only: [:show, :update, :destroy]
  before_action :separate_params, only: [:update, :create]
  skip_before_filter :verify_authenticity_token

  def index
    @rcds = Cookbook.all
  end

  def create
    @rcd = Cookbook.new(permit_params)

    if @rcd.save
      @rcd.process_tags(@tags_from_api)
      @rcd.process_materials(@materials_from_api)
      # TODO: Save record to GSheet with shareable permission
      render json: @rcd, status: :created
    else
      # TODO: render with error code or status code
      render json: { errors: @rcd.errors }
    end
  end

  def show
  end

  def update
    if @rcd.update(permit_params)
      @rcd.process_tags(@tags_from_api)
      @rcd.process_materials(@materials_from_api)
      # TODO: Update GDoc content
      render json: @rcd
    else
      # TODO: render with error code or status code
      render json: { errors: @rcd.errors }
    end
  end

  def destroy
    if @rcd.destroy
      head :no_content
    else
      render json: { errors: @rcd.errors }
    end
  end

  def search
    rcd_ids = Cookbook.all.map(&:id)
    if params[:searchParams].present?
      search_params = params[:searchParams]

      # TODO: Use `send` and loop to remove duplicated code
      rcd_ids &= search_material_ids(search_params[:selected_materials]) \
                 if search_params[:selected_materials].present?

      rcd_ids &= search_tag_name(search_params[:tag_name]) \
                 if search_params[:tag_name].present?

      rcd_ids &= search_cookbook_name(search_params[:cookbook_name]) \
                 if search_params[:cookbook_name].present?

      rcd_ids &= search_cookbook_desc(search_params[:cookbook_desc]) \
                 if search_params[:cookbook_desc].present?

    end

    @rcds = Cookbook.find(rcd_ids)
    render :index
  end

  private

  def prepare_rcd
    @rcd = Cookbook.find(params[:id])
  end

  def separate_params
    @materials_from_api = params.delete(:materials)
    @tags_from_api = params.delete(:tags)

    # Those params are passed from API side, but won't be used in
    # create/update, so tidy them.
    tidy_params(params[:cookbook], [:id, :created_at, :updated_at, :gdoc_url])
  end

  def tidy_params(params_need_tidy, tidy_keys)
    tidy_keys.each do |k|
      params_need_tidy.delete(k) if params_need_tidy.include?(k)
    end
  end

  def permit_params
    params.require(:cookbook).permit([
      :name,
      :image,
      :desc,
      { materials_attributes: [:id, :name, :quantity, :unit, :_destroy] },
      { tags_attributes: [:id, :name] }
    ])
  end

  def search_material_ids(ids)
    Material.where(id: ids).map(&:cookbook_ids).flatten.uniq
  end

  def search_tag_name(name)
    Tag.where(name: name).map(&:cookbook_ids).flatten.uniq
  end

  def search_cookbook_desc(desc)
    Cookbook.where('name ILIKE ?', "%#{desc}%").map(&:id)
  end

  def search_cookbook_name(name)
    Cookbook.where('name ILIKE ?', "%#{name}%").map(&:id)
  end
end
