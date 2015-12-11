# Controller for managing Cookbook record. Since frontend part is handled by
# AngularJS so no new and edit in actions.
class CookbooksController < ApplicationController
  before_action :prepare_rcd, only: [:show, :update, :destroy]
  skip_before_filter :verify_authenticity_token

  def index
    @rcds = Cookbook.all
  end

  def create
    @rcd = Cookbook.new(permit_params)

    if @rcd.save
      @rcd.process_tags(params[:tags])
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
      @rcd.process_tags(params[:tags])
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

  private

  def prepare_rcd
    @rcd = Cookbook.find(params[:id])
  end

  def permit_params
    params.permit([
      :name,
      :image,
      :desc,
      { materials_attributes: [:id, :name, :quantity, :unit, :_destroy] },
      { tags_attributes: [:id, :name] }
    ])
  end
end
