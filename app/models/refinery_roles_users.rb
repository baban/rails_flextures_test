=begin
class RefineryRolesUsers < ActiveRecord::Base
  # attr_accessible :title, :body
end
=end

module Refinery
  class RolesUsers < ActiveRecord::Base
  # class RolesUsers < Refinery::Core::BaseModel
    belongs_to :role
    belongs_to :user
  end
end
