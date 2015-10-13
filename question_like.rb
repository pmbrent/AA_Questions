class QuestionLike

  def self.find_by_id(ql_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, ql_id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL
    QuestionFollow.new(result)
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
    QuestionFollow.new(result)
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
    Reply.new(result)
  end

  attr_accessor :id, :question_id, :user_id

  def initialize(params = {})
    @id = params['id']
    @question_id = params['question_id']
    @user_id = params['user_id']
  end

end
