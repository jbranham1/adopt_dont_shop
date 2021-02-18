class Shelter < ApplicationRecord
  has_many :pets
  validates_presence_of :name
  validates_uniqueness_of :name

  before_save :normalize_name, :normalize_address

  def self.by_reverse_alphabetical
    find_by_sql "select * from shelters order by name desc;"
  end

  def self.shelter_with_name_and_address(id)
    find_by_sql "select id, name, (address || ' ' || city || ', ' || state || ' ' || zip) as full_address from shelters where id = #{id};"
  end

  def self.shelters_with_pending_applications
    joins(pets: [{application_pets: :application}])
    .where(applications: {status: 1})
    .order(:name)
    .distinct
  end

  def average_age_for_adoptable_pets
    pets.where(adoptable: true).average(:approximate_age)
  end

  def count_of_adoptable_pets
    pets.where(adoptable: true).count
  end

  def count_of_adopted_pets
    pets.where(adoptable: false).count
  end

  private

  def normalize_name
    self.name = name.downcase.titleize
  end

  def normalize_address
    self.address = self.address.downcase.titleize
  end
end
