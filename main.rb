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
  attr_reader :if_arrays
  attr_reader :nested_if

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

  def set_if_blocks
    switch = false
    if_indentation = nil
    @if_arrays = []
    if_array = []

    @file_array.map do |line|

      if (if_indentation == line[:indentation]) && (line[:text].include? 'end')
        if_array.push(line)
        @if_arrays.push(if_array)
        if_array = []
        if_indentation = nil
        switch = false
      end

      if (line[:text].include? ' if ') && if_indentation.nil?
        switch = true
        if_indentation = line[:indentation]
      end

      if_array.push(line) if switch
    end
  end

  def find_nested_if
    @nested_if = []

    @if_arrays.map do |array|
      array.map do |line|
        @nested_if.push(line) if (line[:text].include? ' if ') && (line != array[0])
      end
    end
  end

  def prints_nested_if
    return if @nested_if.empty?

    puts 'Nested IF statements have been found'
    @nested_if.map { |line| puts 'File: ' + line[:filename] + ', Line: ' + line[:line_place].to_s + ', Text: ' + line[:text] }
  end
end

file = FileHandler.new('./test_files/cases.rb')
file.set_if_blocks
file.find_nested_if
file.prints_nested_if
