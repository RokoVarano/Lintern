#!/usr/bin/env ruby

require 'timeout'

require_relative '../lib/file_handler'

def print_message
  puts
  puts 'Try combining conditions'
  puts ' instead of: '
  puts '   if true_condition'
  puts '     effect if another_true'
  puts '   end'
  puts
  puts ' do:'
  puts '   effect if another_true && true_condition'
  puts
  puts 'Or use a guard clause, like so:'
  puts '   return unless true_condition && another_true'
  puts '   effect'
  puts
end

again = true

while again

  again = false

  puts 'Please enter relative directory to find nested IF statements. rubocop -a will be executed to enforce alignment'

  quit = false

  directory = ''

  while Dir[directory].empty?

    return if quit

    directory = gets.chomp + '/**/*.rb'

    directory = '.' + directory if directory == '/**/*.rb'

    puts 'No ruby files in directory. Try again or type QUIT(all caps) to exit' if Dir[directory].empty?

    quit = true if directory == 'quit'.upcase + '/**/*.rb'
  end

  system 'rubocop -a'

  puts
  puts '-----End of Rubocop-----'

  fix_message = false

  begin
    Timeout.timeout(1) do
      Dir[directory].map do |dir|
        file = FileHandler.new(dir)
        puts file.warning if file.warning

        next if file.line_print.nil?

        puts
        puts 'Nested IF statements have been found'
        puts
        puts file.line_print
        fix_message = true
      end
      print_message if fix_message
    end
  rescue StandardError
    puts 'Finding items took more than a second. Directory may have too much content'
    again = true
  end
end
