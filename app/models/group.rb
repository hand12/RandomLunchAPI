class Group < ApplicationRecord
  has_many :members, dependent: :destroy
  has_many :restaurants, dependent: :destroy
end
