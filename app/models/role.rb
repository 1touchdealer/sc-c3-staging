class Role < ActiveRecord::Base
  NAMES = %w(member alliance_admin business_admin church_admin super_admin city_director state_director)

  # Define convenience methods, e.g. Role.super_admin
  NAMES.each_with_index do |name, i|
    define_singleton_method(name) do
      # Check first if the role table exists (for initial db setup)
      if ActiveRecord::Base.connection.table_exists? :roles
        Role.find_or_create_by name: name
      else
        OpenStruct.new name: name, id: i + 1
      end
    end
  end
end
