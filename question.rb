class Question

  def self.find_by_id(q_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, q_id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    Question.new(result)
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
    Question.new(result)
  end

  def self.find_by_author_id(author_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?
    SQL
    Question.new(result)
  end

  attr_accessor :id, :title, :body

  def initialize(params = {})
    @id = params['id']
    @title = params['title']
    @body = params['body']
  end

  def author
    

end
