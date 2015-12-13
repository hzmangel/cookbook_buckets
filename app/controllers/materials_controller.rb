# Controller for showing materials to API caller
class MaterialsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @rcds = Material.all
    render json: @rcds
  end
end
