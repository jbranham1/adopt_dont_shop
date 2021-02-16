class Shelter < ApplicationRecord
  has_many :pets
  validates_uniqueness_of :name

  def self.by_reverse_alphabetical
    find_by_sql "select * from shelters order by name desc;"
  end

  def self.shelter_with_name_and_address(id)
    find_by_sql "select name, address, city, state, zip from shelters where id = #{id};"
  end

  def self.shelters_with_pending_applications
    joins(pets: [{application_pets: :application}])
    .where('applications.status' => 1)
    .select('distinct shelters.*')
    .order('shelters.name')
  end

  def average_age_for_adoptable_pets
    # .joins(pets: [{application_pets: :application}])
    # .where('pets.adoptable' => true)
    # .select("pets.*")
    # .average("pets.approximate_age")
    pets.where(adoptable: true).average(:approximate_age)
  end
end
