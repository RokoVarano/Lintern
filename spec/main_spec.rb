require_relative '../bin/main'

describe FileHandler do
  describe '#initialize' do
    it 'sets a warning if a file cannot be read' do
      expect(FileHandler.new('./non_existant/file.rb').warning).to eq('Warning: File could not be read: ' + './non_existant/file.rb')
    end
  end

  describe '#messages' do
    let(:messages) do
      [
        'File: cases.rb, Line: 7, Text:    if the_second',
        "File: cases.rb, Line: 8, Text:       puts 'three nested cases' if the third",
        'File: cases.rb, Line: 19, Text:    unless the_second',
        "File: cases.rb, Line: 20, Text:      puts 'combined  cases' if the third",
        "File: cases.rb, Line: 37, Text:    puts 'the fourth' if the_fourth"
      ]
    end

    it 'creates an array of strings that describe errors' do
      puts FileHandler.new('./spec/cases.rb').messages
      puts
      puts messages

      expect(FileHandler.new('./spec/cases.rb').messages).to eq(messages)
    end
  end
end
