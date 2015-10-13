require 'byebug'
class ModelBase

  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{ self::TABLE_NAME }
      WHERE
        id = ?
    SQL
    result.empty? ? nil : self.new(result[0])
  end

  def self.all
    result = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{ self::TABLE_NAME }
    SQL

    result.map! do |result|
      self.new(result)
    end

    result.empty? ? nil : result
  end

  def method_missing(method_name, *args)
    method_name = method_name.to_s
    if method_name.start_with?("find_by_")
      keywords_string = method_name[("find_by_".length)..-1]

      keywords = keywords_string.split("_and_")

      unless keywords.length == args.length
        raise "unexpected # of arguments"
      end

      search_conditions = {}
      keywords.each_index do |i|
        search_conditions[keywords[i]] = args[i]
      end

      self.find_by(search_conditions)
    else
      super
    end
  end

  def find_by(*conditions)

  end

  def self.where(options = {})
    conditions = []
    values = []

    options.each do |op_key, op_val|
      conditions << "#{op_key} = ?"
      values << op_val
    end

    result = QuestionsDatabase.instance.execute(<<-SQL, *values)
      SELECT
        *
      FROM
        #{ self::TABLE_NAME }
      WHERE
        #{ conditions.join(" AND ") }
    SQL

    result.map! do |result|
      self.new(result)
    end

    result.empty? ? nil : result
  end
end
