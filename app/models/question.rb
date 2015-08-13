class Question < ActiveRecord::Base
  validates :poll_id, :text, presence: true

  belongs_to :poll,
    class_name: "Poll",
    foreign_key: :poll_id,
    primary_key: :id

  has_many :answers,
      class_name: "AnswerChoice",
      foreign_key: :question_id,
      primary_key: :id

  has_one :author,
    :through :poll,
    :source :author


end
