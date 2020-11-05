require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')

def prompt(message)
  puts "==> #{message}"
end

def clear_screen
  system('clear') || system('cls')
end

def messages(message, lang = 'en')
  MESSAGES[lang][message]
end

def valid_number?(num)
  num.match?(/\A-?[0-9]+(.[0-9]+)?\z/)
end

def get_lang
  lang = ''
  loop do
    prompt('Language? English (en) or French (fr)')
    lang = gets.chomp.downcase
    break if ['english', 'en', 'french', 'fr'].include?(lang)
    prompt('Oops. Please enter a valid language')
  end
end

def get_operator
  operator = ''
  loop do
    prompt(messages('operator_prompt', lang))
    operator = gets.chomp

    if %w[1 2 3 4].include?(operator) then break
    else prompt('Must choose 1, 2, 3 or 4') end
  end
  operator
end

def get_number(ordinal_number_word)
  num = 0
  loop do
    prompt("What\'s the #{ordinal_number_word} number?")
    num = gets.chomp

    if valid_number?(num) then break
    else prompt('Oops. Please enter a valid number') end
  end
  num.to_f
end

def operation_to_message(operator)
  case operator
  when '1' then 'Adding'
  when '2' then 'Subtracting'
  when '3' then 'Multiplying'
  when '4' then 'Dividing' end
end

def calculate_result(num1, num2, operator)
  case operator
  when '1' then num1 + num2
  when '2' then num1 - num2
  when '3' then num1 * num2
  when '4' then num1 / num2 end
end

clear_screen()
lang = get_lang

clear_screen()
prompt(messages('greeting', lang))

loop do
  operator = get_operator()

  clear_screen()
  num1 = get_number('first')
  num2 = get_number('second')

  clear_screen()
  prompt("#{operation_to_message(operator)} the numbers...")

  result = calculate_result(num1, num2, operator)
  prompt("The result is: #{result}")

  prompt('Would you like to run a calculation again? (Y to calculate again)')
  answer = gets.chomp.upcase
  break unless answer.start_with?('Y')
  clear_screen()
end

clear_screen()
prompt("Thank you for using the calculator. Good bye!")
