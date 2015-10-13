require_relative 'user'

class QuestionFollow < ModelBase

  def self.all
    super('question_follows')
  end

  def self.find_by_id(qf_id)
    super('question_follows', qf_id)
  end

  def self.find_by_uname(u_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, u_id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        user_id = ?
    SQL

    result.map! do |result|
      QuestionFollow.new(result)
    end

    result.empty? ? nil : result
  end

  def self.followers_for_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        users
      INNER JOIN (
        SELECT
          user_id
        FROM
          question_follows
        WHERE
          question_id = ?
      ) AS uids
      ON users.id = uids.user_id
    SQL

    result.map! do |user|
      User.new(user)
    end

    result.empty? ? nil : result
  end

  def self.followed_questions_for_user_id(user_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      INNER JOIN (
        SELECT
          question_id
        FROM
          question_follows
        WHERE
          user_id = ?
      ) AS qids
      ON questions.id = qids.question_id
    SQL

    result.map! do |user|
      Question.new(user)
    end

    result.empty? ? nil : result
  end

  def self.most_followed_questions(n)
    result = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      questions.id, COUNT(*)
    FROM
      questions
    INNER JOIN (
      SELECT
        *
      FROM
        question_follows
    ) AS qf
    ON qf.question_id = questions.id
    GROUP BY
      questions.id
    ORDER BY
      COUNT(*) DESC
    LIMIT ?
    SQL

    result.map! do |el|
      Question::find_by_id(el[0])
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
