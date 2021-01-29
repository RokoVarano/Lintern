require 'rubygems'
require 'bundler/setup'

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
