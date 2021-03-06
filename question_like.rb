require 'byebug'

class QuestionLike < ModelBase

  TABLE_NAME = 'question_likes'

  def self.where(options)
    super(options)
  end

  def self.all
    super
  end

  def self.find_by_id(ql_id)
    super(ql_id)
  end

  def self.find_by_uname(u_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, u_id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        user_id = ?
    SQL

    result.map! do |result|
      QuestionLike.new(result)
    end

    result.empty? ? nil : result
  end

  def self.find_by_qid(q_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, q_id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL

    result.map! do |result|
      QuestionLike.new(result)
    end

    result.empty? ? nil : result
  end

  def self.likers_for_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      user_id
    FROM
      question_likes
    WHERE
      question_id = ?
    SQL

    result.map! do |result|
      User::find_by_id(result['user_id'])
    end

    result.empty? ? nil : result
  end

  def self.num_likes_for_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)

    SELECT
      COUNT(*) AS num
    FROM
      question_likes
    WHERE
      question_id = ?
    GROUP BY
      question_id
    SQL

    result.first['num']
  end

  def self.liked_questions_for_user_id(user_id)

    result = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      question_id
    FROM
      question_likes
    WHERE
      user_id = ?
    SQL

    result.map! do |result|
      Question::find_by_id(result['question_id'])
    end

    result.empty? ? nil : result
  end

  def self.most_liked_questions(n)
    result = QuestionsDatabase.instance.execute(<<-SQL, n)

    SELECT
      question_id, COUNT(*) AS num
    FROM
      question_likes
    GROUP BY
      question_id
    ORDER BY
      num DESC
    LIMIT ?
    SQL

    result.map! do |result|
      Question::find_by_id(result['question_id'])
    end

    result.empty? ? nil : result
  end

  attr_accessor :id, :question_id, :user_id

  def initialize(params = {})
    @id = params['id']
    @question_id = params['question_id']
    @user_id = params['user_id']
  end

end
