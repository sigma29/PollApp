class Poll < ActiveRecord::Base
  validates :title, :author_id, presence: true

  belongs_to :author,
    class_name: 'Author',
    foreign_key: :author_id,
    primary_key: :id
end
