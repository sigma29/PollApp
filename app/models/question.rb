class Question < ActiveRecord::Base
  validates :poll_id, :text, presence: true

  belongs_to :poll,
    class_name: "Poll",
    foreign_key: :poll_id,
    primary_key: :id

  has_many :answer_choices,
      class_name: "AnswerChoice",
      foreign_key: :question_id,
      primary_key: :id

  has_one :author,
    through: :poll,
    source: :author

  has_many :responses,
    through: :answer_choices,
    source: :responses

  def results

    answer_frequencies = {}

    answers_with_count = self.answer_choices
      .select("answer_choices.*, COUNT(responses.id) AS response_count")
      .joins("LEFT OUTER JOIN responses ON responses.answer_choice_id = answer_choices.id")
      .where("answer_choices.question_id = ?", self.id)
      .group("answer_choices.id")

    answers_with_count.each do |answer|
      answer_frequencies[answer.text] = answer.response_count
    end

    answer_frequencies
  end


end
