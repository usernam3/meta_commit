require 'rspec'

describe MetaCommit::Factories::DiffFactory do
  describe '#create_diff_of_type' do
    let(:create_options) {{
        :line => Rugged::Diff::Line.new,
        :old_file_path => 'old_file_path',
        :new_file_path => 'new_file_path',
        :old_ast_path => double(:old_ast_path, {:parser_class => :parser_obj}),
        :new_ast_path => double(:new_ast_path, {:parser_class => :parser_obj}),
        :commit_id_old => 'commit_id_old',
        :commit_id_new => 'commit_id_new',
    }}
    it 'tries every available diff class' do
      diff_class_1 = double('diff', {:supports_change => false, :supports_parser? => false})
      expect(diff_class_1).to receive(:new).and_return(diff_class_1)
      diff_class_2 = double('diff', {:supports_change => false, :supports_parser? => false})
      expect(diff_class_2).to receive(:new).and_return(diff_class_2)

      subject = MetaCommit::Factories::DiffFactory.new([diff_class_1, diff_class_2])
      subject.create_diff_of_type(:addition, create_options)
    end
    it 'returns nil if supported diff not found' do
      diff_class_1 = double('diff', {:supports_change => false, :supports_parser? => false})
      expect(diff_class_1).to receive(:new).and_return(diff_class_1)

      subject = MetaCommit::Factories::DiffFactory.new([diff_class_1,])
      expect(subject.create_diff_of_type(:addition, create_options)).to be nil
    end
    it 'fills the first supported diff and leaves parser class watermark' do
      diff_class_1 = double('diff', {:supports_change => false, :supports_parser? => false})
      expect(diff_class_1).to receive(:new).and_return(diff_class_1)
      diff_class_2 = double('diff', {:supports_change => true, :supports_parser? => true, })
      expect(diff_class_2).to receive(:diff_type=)
      expect(diff_class_2).to receive(:commit_old=)
      expect(diff_class_2).to receive(:commit_new=)
      expect(diff_class_2).to receive(:old_file=)
      expect(diff_class_2).to receive(:new_file=)
      expect(diff_class_2).to receive(:old_lineno=)
      expect(diff_class_2).to receive(:new_lineno=)
      expect(diff_class_2).to receive(:old_ast_path=)
      expect(diff_class_2).to receive(:new_ast_path=)
      expect(diff_class_2).to receive(:new).and_return(diff_class_2)

      subject = MetaCommit::Factories::DiffFactory.new([diff_class_1, diff_class_2])
      created_diff = subject.create_diff_of_type(:addition, create_options)

      expect(created_diff).to be(diff_class_2)
    end
  end
end
