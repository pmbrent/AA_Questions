require 'byebug'
class ModelBase

  def self.find_by_id(table, id)
    #debugger
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table}
      WHERE
        id = ?
    SQL
    result.empty? ? nil : self.new(result[0])
  end

  def self.all(table)
    result = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table}
    SQL

    result.map! do |result|
      self.new(result)
    end

    result.empty? ? nil : result
  end

  def save
  end

end
