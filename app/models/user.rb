class User < ActiveRecord::Base
  validates :user_name, presence: true, uniqueness: true

  has_many :authored_polls,
    class_name: "Poll",
    foreign_key: :author_id,
    primary_key: :id

  has_many :responses,
    class_name: "Response",
    foreign_key: :user_id,
    primary_key: :id

  has_many :authored_questions,
    through: :authored_polls,
    source: :questions

  has_many :authored_answer_choices,
    through: :authored_questions,
    source: :answers

  private




end
