require_relative 'question'

class User

  def self.find_by_id(u_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, u_id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    result.empty? ? nil : User.new(result[0])
  end

  def self.find_by_name(fname, lname)
    result = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    result.map! do |result|
      User.new(result)
    end
    result.empty? ? nil : result
  end

  attr_accessor :id, :fname, :lname

  def initialize(params = {})
    @id = params['id']
    @fname = params['fname']
    @lname = params['lname']
  end

  def authored_questions
    Question::find_by_author_id(self.id)
  end

  def authored_replies
    Reply::find_by_user_id(self.id)
  end

  def followed_questions
    QuestionFollow::followed_questions_for_user_id(self.id)
  end

  def liked_questions
    QuestionLike::liked_questions_for_user_id(self.id)
  end

end
