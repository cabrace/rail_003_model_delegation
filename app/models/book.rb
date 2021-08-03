class Book < ApplicationRecord
  belongs_to :author
  delegate :name, to: :author, prefix: true
end
