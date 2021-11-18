class Question < ApplicationRecord
  #Associations
  belongs_to :user
  
  #Validations
  validates :text, presence: true, length: { maximum: 255 }
end
