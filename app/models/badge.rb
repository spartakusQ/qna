class Badge < ApplicationRecord
  belongs_to :question
  has_one_attached :image, dependent: :destroy

  validates :title, presence: true
end
