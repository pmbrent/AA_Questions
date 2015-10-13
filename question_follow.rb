class QuestionFollow

  def self.find_by_id(qf_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, qf_id)
      SELECT
        *
      FROM
        question_follows
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
        question_follows
      WHERE
        user_id = ?
    SQL
    QuestionFollow.new(result)
  end

  attr_accessor :id, :question_id, :user_id

  def initialize(params = {})
    @id = params['id']
    @question_id = params['question_id']
    @user_id = params['user_id']
  end

end
