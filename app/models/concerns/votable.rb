module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating_up(user)
    vote(user, 1)
  end

  def rating_down(user)
    vote(user, -1)
  end

  def rating_sum
    votes.sum(:rating)
  end

  private

  def vote(user, rate)
    votes.create!(user: user, rating: rate) unless user.voted?(self)
  end
end
