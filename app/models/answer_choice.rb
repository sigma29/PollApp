class AnswerChoice < ActiveRecord::Base
  validates :text, :question_id, presence: true

  belongs_to :question,
    class_name: "Question",
    foreign_key: :question_id,
    primary_key: :id
end
