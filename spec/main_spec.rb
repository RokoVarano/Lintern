require_relative '../main'

describe FileHandler do
  describe '#initialize' do
    it 'sets an array of hashes with their respective __LINE__ and __FILE__' do
    end
    it 'returns an error if the file cannot be read' do
    end
    it 'closes the current file' do
    end
  end

  describe '#to_s' do
    it 'returns a string with the file status and the current collection of lines' do
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
