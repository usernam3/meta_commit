require 'spec_helper'

describe MetaCommit::Changelog::Commands::CommitDiffExaminer do
  describe '#meta' do
    let(:parse_command) {double(:parse_command)}
    let(:ast_path_factory) {double(:ast_path_factory)}
    let(:diff_factory) {double(:diff_factory)}
    let(:diff_lines_provider) {double(:diff_lines_provider)}

    let(:old_file_path) {double(:old_file_path)}
    let(:old_file_content) {:old_file_content}
    let(:old_file_oid) {:old_file_oid}
    let(:old_ast) {double(:old_ast)}
    let(:old_ast_path) {double(:old_ast_path)}
    let(:new_file_path) {double(:new_file_path)}
    let(:new_file_content) {:new_file_content}
    let(:new_file_oid) {:new_file_oid}
    let(:new_ast) {double(:new_ast)}
    let(:new_ast_path) {double(:new_ast_path)}

    let(:patch) {double(:patch)}
    let(:line) {double(:line, {:line_origin => 1, :old_lineno => 'old_lineno', :new_lineno => 'new_lineno'})}
    let(:ast_mock) {double(:ast_mock)}
    let(:created_diff) {double(:created_diff)}

    subject do
      MetaCommit::Changelog::Commands::CommitDiffExaminer.new(parse_command, ast_path_factory, diff_factory, diff_lines_provider)
    end

    it 'passes commits to repo' do
      repo = double(:repo)
      diff = double(:diff)
      left = double(:left, {:oid => 'left'})
      right = double(:right, {:oid => 'right'})

      expect(repo).to receive(:diff).with(left, right, anything)
                          .and_return(diff)
      expect(diff_lines_provider).to receive(:from).with(diff)
                                         .and_return([])

      subject.meta(repo, left, right)
    end
    it 'skips if parsed old file is nil' do
      repo = double(:repo)
      diff = double(:diff)
      left = double(:left, {:oid => old_file_oid})
      right = double(:right, {:oid => new_file_oid})

      expect(repo).to receive(:diff).with(left, right, anything)
                          .and_return(diff)
      expect(diff_lines_provider).to receive(:from).with(diff)
                                         .and_return([
                                                         [old_file_path, new_file_path, patch, line]
                                                     ])

      expect(repo).to receive(:get_blob_at).with(anything, old_file_path, anything).and_return(old_file_content)
      expect(repo).to receive(:get_blob_at).with(anything, new_file_path, anything).and_return(new_file_content)

      expect(parse_command).to receive(:execute).with(old_file_path, old_file_content)

      expect(subject.meta(repo, left, right)).to be_empty
    end
    it 'skips if parsed new file is nil' do
      repo = double(:repo)
      diff = double(:diff)
      left = double(:left, {:oid => old_file_oid})
      right = double(:right, {:oid => new_file_oid})

      expect(repo).to receive(:diff).with(left, right, anything)
                          .and_return(diff)
      expect(diff_lines_provider).to receive(:from).with(diff)
                                         .and_return([
                                                         [old_file_path, new_file_path, patch, line]
                                                     ])

      expect(repo).to receive(:get_blob_at).with(anything, old_file_path, anything).and_return(old_file_content)
      expect(repo).to receive(:get_blob_at).with(anything, new_file_path, anything).and_return(new_file_content)

      expect(parse_command).to receive(:execute).with(old_file_path, old_file_content).and_return(ast_mock)
      expect(parse_command).to receive(:execute).with(new_file_path, new_file_content)

      expect(subject.meta(repo, left, right)).to be_empty
    end
    it 'passes parameters to diff factory' do
      repo = double(:repo)
      diff = double(:diff)
      left = double(:left, {:oid => old_file_oid})
      right = double(:right, {:oid => new_file_oid})
      patch = double(:patch, {:delta => double(:delta, {
          :new_file => {:oid => :oid},
          :old_file => {:oid => :oid},
      })})

      expect(repo).to receive(:diff).with(left, right, anything)
                          .and_return(diff)
      expect(diff_lines_provider).to receive(:from).with(diff)
                                         .and_return([
                                                         [old_file_path, new_file_path, patch, line]
                                                     ])

      expect(repo).to receive(:get_blob_at).with(anything, old_file_path, anything).and_return(old_file_content)
      expect(repo).to receive(:get_blob_at).with(anything, new_file_path, anything).and_return(new_file_content)

      expect(line).to receive(:compute_column).and_return(3)

      expect(parse_command).to receive(:execute).with(old_file_path, old_file_content).and_return(old_ast)
      expect(parse_command).to receive(:execute).with(new_file_path, new_file_content).and_return(new_ast)

      expect(ast_path_factory).to receive(:create_contextual_node).with(old_ast, anything).and_return(old_ast_path)
      expect(ast_path_factory).to receive(:create_contextual_node).with(new_ast, anything).and_return(new_ast_path)


      expect(diff_factory).to receive(:create_diff)
                                  .with({
                                            :line => line,
                                            :column => 3,
                                            :commit_id_old => old_file_oid,
                                            :commit_id_new => new_file_oid,
                                            :old_contextual_ast => old_ast_path,
                                            :new_contextual_ast => new_ast_path,
                                            :old_file_path => old_file_path,
                                            :new_file_path => new_file_path,
                                        }).and_return(created_diff)

      expect(subject.meta(repo, left, right)).to include(created_diff)
    end
  end
end