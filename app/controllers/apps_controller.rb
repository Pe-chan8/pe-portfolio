class AppsController < ApplicationController
  def index
    @q = App.ransack(params[:q])
    @apps = @q.result(distinct: true).includes(:tags)
  end

  def show
    @app = App.includes(:tags).find(params[:id])
  end
end
