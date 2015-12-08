# Controller for managing Cookbook record. Since frontend part is handled by
# AngularJS so no new and edit in actions.
class CookbooksController < ApplicationController
  before_action :prepare_rcd, only: [:show, :update, :destroy]

  def index
    @rcds = Cookbook.all
  end

  def create
    # TODO: Save record to Database
    # TODO: Save record to GSheet, shareable
  end

  def show
  end

  def update
  end

  def destroy
    @rcd.destroy
  end

  private

  def prepare_rcd
    @rcd = Cookbook.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end
end
