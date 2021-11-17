class Question < ApplicationRecord
  #Associations
  belongs_to :user
  
  #Validations
  validates :text, :user, presence: true, length: { maximum: 255 }
end
