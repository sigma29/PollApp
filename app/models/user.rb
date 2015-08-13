class User < ActiveRecord::Base
  has_many :authored_polls,
    class_name: "Poll",
    foreign_key: :author_id,
    primary_key: :id
end
