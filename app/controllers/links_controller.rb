class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_link

  def destroy
    if current_user.author?(@link.linkable)
      @link.destroy
      flash[:notice] = 'Link successfully deleted.'
      # redirect_to request.referrer, notice: 'Link successfully deleted.'
    else
      redirect_to @link.linkable
      flash[:notice] = 'Only author can deleted Link.'
    end
  end

  private

  def find_link
    @link = Link.find(params[:id])
  end
end
