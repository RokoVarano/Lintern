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
    @file_array.map { |line| puts line[:indentation] }
    file.close
  rescue StandardError
    @warning = 'Warning: File could not be read: ' + file_path
  end

  def set_if_blocks
  end
end
