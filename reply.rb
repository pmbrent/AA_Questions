class Reply < ModelBase

  TABLE_NAME = 'replies'

  def self.where(options)
    super(options)
  end

  def self.all
    super
  end

  def self.find_by_id(r_id)
    super(r_id)
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

    result.map! do |result|
      Reply.new(result)
    end

    result.empty? ? nil : result
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

    result.map! do |result|
      Reply.new(result)
    end

    result.empty? ? nil : result
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

    result.map! do |result|
      Reply.new(result)
    end

    result.empty? ? nil : result
  end

  attr_accessor :id, :question_id, :user_id, :parent_id, :body

  def initialize(params = {})
    @id = params['id']
    @question_id = params['question_id']
    @parent_id = params['parent_id']
    @user_id = params['user_id']
    @body = params['body']
  end


  def author
    User::find_by_id(user_id)
  end

  def question
    Question::find_by_id(question_id)
  end

  def parent_reply
    Reply::find_by_id(parent_id)
  end

  def child_replies
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        id
      FROM
        replies
      WHERE
        parent_id = ?
    SQL

    replies = []
    result.each do | _, reply_id|
      replies << Reply::find_by_id(reply_id)
    end

    replies
  end

  def save
    if self.id.nil?
      QuestionsDatabase.instance.execute(
      <<-SQL, self.question_id, self.parent_id, self.user_id, self.body)
      INSERT INTO
        replies (question_id, parent_id, user_id, body)
      VALUES
        (?, ?, ?, ?)
      SQL

      self.id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(
      <<-SQL, self.question_id, self.parent_id, self.user_id, self.body)
      UPDATE
        replies
      SET
        question_id = ?, parent_id = ?, user_id = ?, body = ?
      WHERE
        id = ?
      SQL
    end
  end


end
