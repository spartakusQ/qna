class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:votable_type, :votable_id] }
  validates_inclusion_of :rating, in: -1..1
end
