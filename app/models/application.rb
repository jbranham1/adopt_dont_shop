class Application < ApplicationRecord
  has_many :application_pets
  has_many :pets, through: :application_pets

  validates_presence_of :first_name, :last_name

  validates :zipcode, numericality: {
              greater_than_or_equal_to: 0
            }

  enum status: [:in_progress, :pending, :approved, :rejected]
  before_save :default_values

  def default_values
    status ||= :in_progress
  end

  def update_pet_adoption_status
    pets.each do |pet|
      pet.update!(adoptable: false)
      pet.save
    end
  end
end
