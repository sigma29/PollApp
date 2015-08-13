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
    source: :answer_choices


  def completed_polls
    user_responses = <<-SQL
      LEFT OUTER JOIN (
        SELECT
          responses.*
        FROM
          responses
        WHERE
          responses.user_id = #{self.id}
      ) AS user_responses
      ON
        user_responses.answer_choice_id = answer_choices.id
    SQL

    Poll
      .joins(questions: :answer_choices)
      .joins(user_responses)
      .group("polls.id")
      .having("COUNT(user_responses.answer_choice_id) =
        COUNT(DISTINCT questions.id)")
  end

end
