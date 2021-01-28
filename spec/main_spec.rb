require_relative '../bin/file_handler'

describe FileHandler do
  describe '#initialize' do
    let(:file_dir) { './spec/cases.rb' }
    it 'creates an array with all lines in a file, formatted as a hash' do
      FileHandler.new(file_dir).file_array.map do |line|
        expect(line).to be_a(Hash)
      end
    end
    it 'gives each line a text parameter containing a string' do
      FileHandler.new(file_dir).file_array.map do |line|
        expect(line[:text]).to be_a(String)
      end
    end
    it 'line_place parameter equal to the line number' do
      FileHandler.new(file_dir).file_array.each_with_index.map do |line, index|
        expect(line[:line_place]).to eq(index + 1)
      end
    end
    it 'filename parameter describes the filename (not the whole directory)' do
      FileHandler.new(file_dir).file_array.map do |line|
        expect(line[:filename]).to eq(File.basename(file_dir))
      end
    end
    it 'indentation parameter describes the number of empty before the characters' do
      FileHandler.new(file_dir).file_array.map do |line|
        expect(line[:indentation]).to eq(line[:text][/\A */].size)
      end
    end
    it 'sets a warning if a file cannot be read' do
      expect(FileHandler.new('./not/file.rb').warning).to eq('Warning: File could not be read: ' + './not/file.rb')
    end
  end

  describe '#messages' do
    it 'considers nest if-end blocks' do
      included = false
      FileHandler.new('./spec/cases.rb').line_print.map do |line|
        included = true if line.include? 'Line: 8'
      end
      expect(included).to be true
    end

    it 'considers nested single-line if statements' do
      included = false
      FileHandler.new('./spec/cases.rb').line_print.map do |line|
        included = true if line.include? 'Line: 9'
      end
      expect(included).to be true
    end

    it 'considers nest unless-end blocks' do
      included = false
      FileHandler.new('./spec/cases.rb').line_print.map do |line|
        included = true if line.include? 'Line: 20'
      end
      expect(included).to be true
    end

    it 'considers nested single-line if statements inside unless blocks' do
      included = false
      FileHandler.new('./spec/cases.rb').line_print.map do |line|
        included = true if line.include? 'Line: 21'
      end
      expect(included).to be true
    end

    it 'considers nested single-line if statements where an if in-string word is present' do
      included = false
      FileHandler.new('./spec/cases.rb').line_print.map do |line|
        included = true if line.include? 'Line: 44'
      end
      expect(included).to be true
    end

    it 'excludes single-line if statements which are by themselves' do
      excluded = true
      FileHandler.new('./spec/cases.rb').line_print.map do |line|
        excluded = false if line.include? 'Line: 30'
      end
      expect(excluded).to be true
    end

    it 'excludes single-line unless statements which are by themselves' do
      excluded = true
      FileHandler.new('./spec/cases.rb').line_print.map do |line|
        excluded = false if line.include? 'Line: 32'
      end
      expect(excluded).to be true
    end

    it 'excludes comments inside if blocks that contain the if or the unless word ' do
      excluded = true
      FileHandler.new('./spec/cases.rb').line_print.map do |line|
        excluded = false if line.include? 'Line: 40'
      end
      expect(excluded).to be true
    end

    it 'excludes lines that include the if or unless word inside a string' do
      excluded = true
      FileHandler.new('./spec/cases.rb').line_print.map do |line|
        excluded = false if line.include? 'Line: 48'
      end
      expect(excluded).to be true
    end
  end
end
