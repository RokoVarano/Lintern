require 'rubygems'
require 'bundler/setup'

# 1. The program reads the file and gets an array of hashes.
# A list of offenses is needed to plan their corresponding detecting methods
# - nested if methods -> Use guard classes
# - repetitive conditions in loops inside if statements -> summerize the condition at the end of the loop
# - case or if statements with similar effects -> use .map
# - useless 'else' statements (when if statements return) -> use if as a guard statements
# 2. it detects offenses by looking at key errors, repetitions and unnescesarily nested statements

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

    print_message unless messages.empty?

    messages
  end

  private

  def print_message
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

Dir['./**/*.rb'].map do |dir|
  file = FileHandler.new(dir)
  if file.warning
    puts file.warning
  else
    puts file.line_print
  end
end
