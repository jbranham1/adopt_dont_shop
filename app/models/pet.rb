class Pet < ApplicationRecord
  belongs_to :shelter
  has_many :application_pets
  has_many :applications, through: :application_pets

  validates_presence_of :name, :description, :approximate_age, :sex

  validates :approximate_age, numericality: {
              greater_than_or_equal_to: 0
            }
  validates :name, uniqueness: {case_sensitive: false}
  enum sex: [:female, :male]

  def self.find_by_name(name)
    where("name ilike ?", "%#{name}%")
  end

  def approved_application?
    applications.any?(&:approved?)
  end

  def pending_application?
    applications.any?(&:pending?)
  end

  def adoption_status
    if adoptable
      "Not Adopted"
    else
      "Adopted"
    end
  end
end
