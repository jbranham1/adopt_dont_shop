class Application < ApplicationRecord
  has_many :application_pets
  has_many :pets, through: :application_pets

  validates_presence_of :first_name, :last_name

  validates :zipcode, numericality: {
              greater_than_or_equal_to: 0
            }

  enum status: [:in_progress, :pending, :approved, :rejected]
  before_save :default_values,
              :normalize_first_name,
              :normalize_last_name,
              :normalize_address

  def update_pet_adoption_status
    pets.each do |pet|
      pet.update!(adoptable: false)
    end
  end

  private

  def default_values
    status ||= :in_progress
  end

  def normalize_first_name
    self.first_name = first_name.downcase.titleize
  end

  def normalize_last_name
    self.last_name = last_name.downcase.titleize
  end

  def normalize_address
    self.address = address.downcase.titleize
  end
end
