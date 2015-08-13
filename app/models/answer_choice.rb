class AnswerChoice < ActiveRecord::Base
  validates :text, :question_id, presence: true

  belongs_to :question,
    class_name: "Question",
    foreign_key: :question_id,
    primary_key: :id

  has_many :responses,
    class_name: "Response",
    foreign_key: :answer_choice_id,
    primary_key: :id
    
  has_one :author,
  through: :question,
  source: :author
end
