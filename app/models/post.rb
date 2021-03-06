class Post < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader 
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }  # validate presence of content and also max 140 characters
  validate  :picture_size
  has_many :likes, dependent: :destroy
  has_many :dislikes, dependent: :destroy

  private 

    # Validates the size of an uploaded picture.
    def picture_size
        if picture.size > 5.megabytes
          errors.add(:picture, "should be less than 5MB")
        end
    end
end
