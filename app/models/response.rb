class Response < ActiveRecord::Base
  validates :user_id, :answer_choice_id, presence: true
  validate :author_cant_respond_to_own_poll
  validate :respondent_has_not_already_answered_question


  belongs_to :answer_choice,
    class_name: "AnswerChoice",
    foreign_key: :answer_choice_id,
    primary_key: :id

  belongs_to :respondent,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  has_one :question,
    through: :answer_choice,
    source: :question

  def sibling_responses

    big_joins = (<<-SQL
      AS current_response
      JOIN
        answer_choices AS current_answer
      ON
        current_answer.id = current_response.answer_choice_id
      JOIN
        questions
      ON
        current_answer.question_id = questions.id
      JOIN
        answer_choices AS all_answers
      ON
        all_answers.question_id = questions.id
      JOIN
        responses AS all_responses
      ON
        all_responses.answer_choice_id = all_answers.id
    SQL
    )

    Response
      .joins(big_joins).select('all_responses.*')
      .where("current_answer.id = ?
          AND all_responses.id != ? OR ? IS NULL",
          self.answer_choice_id, self.id, self.id )
      .distinct
  end

  def respondent_has_not_already_answered_question
    self.sibling_responses.each do |sibling|
      if sibling.user_id == self.user_id
        errors[:user_id] << "can't respond to the same question!"
      end
    end
  end

  def author_cant_respond_to_own_poll

    poll_author =
      Poll
      .joins(questions: :answer_choices)
      .where('answer_choices.id = ?', self.answer_choice_id)
      .first
      .author_id

    if poll_author == self.user_id
      errors[:user_id] << "can't respond to your own poll"
    end

  end
end
