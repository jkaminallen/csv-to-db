require 'pg'
require 'csv'

def db_connection
  begin
    connection = PG.connect(dbname: "recipe")
    yield(connection)
  ensure
    connection.close
  end
end

CSV.foreach("ingredients.csv") do |row|
  db_connection do |conn|
    conn.exec_params("INSERT INTO ingredients (ingredient) VALUES ('#{row[1]}')")
  end
end

@ingredients = db_connection { |conn| conn.exec("SELECT steps, ingredient FROM ingredients") }
@ingredients.each do |ingredient|
  puts "#{ingredient["steps"]}. #{ingredient["ingredient"]}"
end
