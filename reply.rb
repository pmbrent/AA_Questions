class Reply

  def self.find_by_id(r_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, r_id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    Reply.new(result)
  end

  def self.find_by_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    Reply.new(result)
  end

  def self.find_by_pid(p_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, p_id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL
    Reply.new(result)
  end

  def self.find_by_user_id(user_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    Reply.new(result)
  end

  attr_accessor :id, :question_id, :user_id

  def initialize(params = {})
    @id = params['id']
    @question_id = params['question_id']
    @parent_id = params['parent_id']
    @user_id = params['user_id']
    @body = params['body']
  end

end
