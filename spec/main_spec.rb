require_relative '../main'

describe FileHandler do
  describe '#initialize' do
    it 'sets an array of hashes with their respective __LINE__ and __FILE__' do
      example_case = [
        { text: "'this is line 1'", line_place: 1, filename: 'file_handler_initialize.rb' },
        { text: "'and this is line 2'", line_place: 2, filename: 'file_handler_initialize.rb' },
        { text: "", line_place: 3, filename: 'file_handler_initialize.rb' },
        { text: "'which takes us to line 3'", line_place: 4, filename: 'file_handler_initialize.rb' },
        { text: "'to finally conclude in line 4'", line_place: 5, filename: 'file_handler_initialize.rb' }
      ]

      mock_file = FileHandler.new('./test_files/file_handler_initialize.rb')
      expect(mock_file.file_array).to eq(example_case)
    end
    it 'returns a warning if a file cannot be read' do
      expect(FileHandler.new('./non_existant/file.rb').warning).to eq('Warning: File could not be read: ' + './non_existant/file.rb')
    end
  end

  describe '#search' do
    it 'returns all lines with a specific __LINE__' do
    end
    it 'returns all lines with a specific __FILE__' do
    end
    it 'returns all lines with a specific __LINE__ and __FILE__' do
    end
  end

  describe '#find_if' do
    it 'sets all if statements and its corresponding lines' do
    end
  end

  describe '#find_loop' do
    it 'sets all loop statements and its corresponding lines' do
    end
  end
end
