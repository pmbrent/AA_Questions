require 'byebug'
require './model_base'

class Question < ModelBase

  def self.all
    super('questions')
  end

  def self.find_by_id(q_id)
    super('questions', q_id)
  end

  def self.find_by_title(q_title)
    result = QuestionsDatabase.instance.execute(<<-SQL, q_title)
      SELECT
        *
      FROM
        questions
      WHERE
        title = ?
    SQL
    result.map! do |result|
      Question.new(result)
    end
    result.empty? ? nil : result
  end

  def self.find_by_author_id(author_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL
    result.map! do |result|
      Question.new(result)
    end
    result.empty? ? nil : result
  end

  def self.most_followed(n)
    QuestionFollow::most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionFollow::most_liked_questions(n)
  end

  attr_accessor :id, :author_id, :title, :body

  def initialize(params = {})
    @id = params['id']
    @author_id = params['author_id']
    @title = params['title']
    @body = params['body']
  end

  def author
    User::find_by_id(author_id)
  end

  def replies
    Reply::find_by_question_id(id)
  end

  def followers
    QuestionFollow::followers_for_question_id(self.id)
  end

  def likers
    QuestionFollow::likers_for_question_id(self.id)
  end

  def num_likes
    QuestionFollow::num_likes_for_question_id(self.id)
  end

  def save
    if self.id.nil?
      QuestionsDatabase.instance.execute(
      <<-SQL, self.author_id, self.title, self.body)
      INSERT INTO
        questions (author_id, title, body)
      VALUES
        (?, ?, ?)
      SQL

      self.id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(
      <<-SQL, self.author_id, self.title, self.body, self.id)
      UPDATE
        questions
      SET
        author_id = ?, title = ?, body = ?
      WHERE
        id = ?
      SQL
    end
  end

end
