class Like < ApplicationRecord
    belongs_to :user
    belongs_to :post
    
    validates :user, uniqueness: { scope: :post, message: "You can like only once" }
  end
  