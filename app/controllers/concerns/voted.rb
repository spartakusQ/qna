module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [ :rating_up, :rating_down, :revote]
  end

  def rating_up
    unless current_user.author?(@votable)
      @votable.rating_up(current_user)
      render_json
    end
  end

  def rating_down
    unless current_user.author?(@votable)
      @votable.rating_down(current_user)
      render_json
    end
  end

  def revote
    unless current_user.author?(@votable)
      @votable.votes.find_by(user_id: current_user)&.destroy
      render_json
    end
  end

  private

  def render_json
    render json: { rating: @votable.rating_sum, klass: @votable.class.to_s, id: @votable.id }
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
