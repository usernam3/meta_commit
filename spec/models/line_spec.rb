require 'spec_helper'

describe MetaCommit::Models::Line do
  describe '#compute_column' do
    let (:old_file_content) { ' \n \n \n \n \n \n' }
    let (:empty_old_file_content) { '' }
    let (:new_file_content) { ' \n \n \n \n \n \n' }
    let (:empty_new_file_content) { '' }

    [
        [" \n \n \n \n    ", " \n \n \n \n    X", 5, 4],
        ['                     ', '                    X', 1, 20],
        ['12345678901', '12345', 1, 5],
        ['12345', '12345678901', 1, 5],
        [" \n ", " \n    class Configuration", 2, 1]
    ].each_with_index do |(old_content, new_content, lineno, expected_column), index|
      it "computes line offset on data set #{index}" do

        line = MetaCommit::Models::Line.new
        line.line_origin = :replace
        line.old_lineno = lineno
        line.new_lineno = lineno

        expect(line.compute_column(old_content, new_content)).to be == expected_column
      end
    end

    it 'does not compute offset when string is added' do
      line = MetaCommit::Models::Line.new
      line.old_lineno = -1
      line.new_lineno = 35

      expect(line.compute_column(old_file_content, new_file_content)).to be_nil
    end

    it 'does not compute offset when string is deleted' do
      line = MetaCommit::Models::Line.new
      line.old_lineno = 35
      line.new_lineno = -1

      expect(line.compute_column(old_file_content, new_file_content)).to be_nil
    end
  end
end