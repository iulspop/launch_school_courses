# ! /usr/bin/env ruby

require "pg"

def list_expenses
  connection = PG.connect(dbname: "expenses")

  result = connection.exec("SELECT * FROM expenses ORDER BY created_on ASC")
  result.each do |tuple|
    columns = [ tuple["id"].rjust(3),
                tuple["created_on"].rjust(10),
                tuple["amount"].rjust(12),
                tuple["memo"] ]

    puts columns.join(" | ")
  end
end

def display_help
  puts <<~HELP
    An expense recording system

    Commands:

    add AMOUNT MEMO [DATE] - record a new expense
    clear - delete all expenses
    list - list all expenses
    delete NUMBER - remove expense with id NUMBER
    search QUERY - list expenses with a matching memo field
  HELP
end

def add_expense
  return puts("You must provide an amount and memo") if ARGV[1].nil? || ARGV[2].nil?
  return puts("You must enter a positive number") if ARGV[1].match?(/[^0-9.]/)

  amount = ARGV[1]
  memo = ARGV[2].gsub("'", "''")
  connection = PG.connect(dbname: "expenses")

  connection.exec("INSERT INTO expenses (amount, memo) VALUES (#{amount}, #{memo}")
end

command = ARGV.first
case command
when "add" then add_expense
when "list" then list_expenses
else
  display_help
end