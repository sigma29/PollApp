class Poll < ActiveRecord::Base
  belongs_to :author,
    class_name: 'Author',
    foreign_key: :author_id,
    primary_key: :id
end
