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
    self.question.responses.where("responses.id != ? OR ? IS NULL", self.id, self.id)
  end

#ask why this fires twice
  def respondent_has_not_already_answered_question
    self.sibling_responses.each do |sibling|
      if sibling.user_id = self.user_id
        errors[:user_id] << "can't respond to the same question!"
      end
    end
  end

  def author_cant_respond_to_own_poll
    if self.answer_choice.question.author.id = self.user_id
      errors[:user_id] << "can't respond to your own poll"
    end
  end
end
