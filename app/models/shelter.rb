class Shelter < ApplicationRecord
  has_many :pets

  def self.by_reverse_alphabetical
    find_by_sql "select * from shelters order by name desc;"
  end

  def self.shelter_with_name_and_address(id)
    find_by_sql "select name, address, city, state, zip from shelters where id = #{id};"
  end
end
