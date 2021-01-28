require 'rubygems'
require 'bundler/setup'
require 'timeout'

Bundler.require(:default)

class FileHandler
  attr_reader :file_array
  attr_reader :warning

  def initialize(file_path)
    file = File.new(file_path)
    filename = File.basename(file_path)
    file_array = []
    file.readlines.each_with_index.map do |line, index|
      file_array.push({
                        text: line.chomp,
                        line_place: index + 1,
                        filename: filename,
                        indentation: line[/\A */].size
                      })
    end
    @file_array = file_array
    file.close
  rescue StandardError
    @warning = 'Warning: File could not be read: ' + file_path
  end

  def line_print
    set_if_blocks
    nested = find_nested_if
    messages = []

    return if nested.empty?

    nested.map do |line|
      messages.push('File: ' + line[:filename] + ', Line: ' + line[:line_place].to_s + ', Text: ' + line[:text].strip)
    end

    messages
  end

  private

  def set_if_blocks
    switch = false
    if_indentation = nil
    if_arrays = []
    if_array = []

    @file_array.map do |line|
      if if_indentation == line[:indentation]
        if_arrays.push(if_array)
        if_array = []
        if_indentation = nil
        switch = false
      end

      if starter_line(line, if_indentation) && !singleline(line)
        switch = true
        if_indentation = line[:indentation]
      end

      if_array.push(line) if switch && valid_line(line)
    end

    if_arrays
  end

  def singleline(line)
    return false if line[:text].split(' ')[0] == 'if'

    true
  end

  def valid_line(line)
    return false if line[:text].strip[0] == '#'

    return false if in_string(line)

    true
  end

  def in_string(line)
    return false unless line[:text].include? "'"

    split_line = line[:text].split(/'(.*?)'/)
    split_line.map do |piece|
      return false if piece.include?(' if ' || ' unless ') && piece != line[:text][/'(.*?)'/, 1]
    end

    true
  end

  def starter_line(line, if_indentation)
    return false unless (line[:text].include? ' if ') || (line[:text].include? ' unless ')
    return false unless if_indentation.nil?

    true
  end

  def find_nested_if
    nested_if = []

    set_if_blocks.map do |array|
      array.map do |line|
        if ((line[:text].include? ' if ') || (line[:text].include? ' unless ')) && (line != array[0])
          nested_if.push(line)
        end
      end
    end

    nested_if
  end
end

def print_message
  puts
  puts 'Nested IF statements have been found'
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

    puts directory + ': No ruby files in directory. Try again or type QUIT(all caps) to exit' if Dir[directory].empty?

    quit = true if directory == 'quit'.upcase + '/**/*.rb'
  end

  system 'rubocop -a'

  fix_message = false

  begin
    Timeout.timeout(10) do
      Dir[directory].map do |dir|
        file = FileHandler.new(dir)
        puts file.warning if file.warning

        unless file.line_print.nil?
          puts file.line_print
          fix_message = true
        end
      end
      print_message if fix_message
    end
  rescue StandardError
    puts 'Finding items took more than 10 seconds. Directory may have too much content'
    again = true
  end
end
