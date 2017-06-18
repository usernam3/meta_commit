require 'rspec'

describe MetaCommit::Models::Factories::DiffFactory do
  describe '#create_diff_of_type' do
    let(:create_options) { {
        :line => Rugged::Diff::Line.new,
        :old_file_path => 'old_file_path',
        :new_file_path => 'new_file_path',
        :old_ast_path => 'old_ast_path',
        :new_ast_path => 'new_ast_path',
        :commit_id_old => 'commit_id_old',
        :commit_id_new => 'commit_id_new',
    } }
    it 'tries every available diff class' do
      diff_class_1 = double('diff', :supports_change => false)
      expect(diff_class_1).to receive(:new).and_return(diff_class_1)
      diff_class_2 = double('diff', :supports_change => false)
      expect(diff_class_2).to receive(:new).and_return(diff_class_2)

      subject.available_diff_classes = [diff_class_1, diff_class_2]
      subject.create_diff_of_type(:addition, create_options)
    end
    it 'fills the first supported diff' do
      diff_class_1 = double('diff', :supports_change => false)
      expect(diff_class_1).to receive(:new).and_return(diff_class_1)

      diff_class_2 = MetaCommit::Models::Diffs::Diff

      subject.available_diff_classes = [diff_class_1, diff_class_2]
      created_diff = subject.create_diff_of_type(:addition, create_options)

      expect(created_diff).to be_a(MetaCommit::Models::Diffs::Diff)
    end
  end
end
