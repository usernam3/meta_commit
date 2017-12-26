module MetaCommit::Changelog
  module Commands
    class CommitDiffExaminer
      # @param [MetaCommit::Services::Parse] parse_command
      # @param [MetaCommit::Factories::ContextualAstNodeFactory] ast_path_factory
      # @param [MetaCommit::Factories::DiffFactory] diff_factory
      def initialize(parse_command, ast_path_factory, diff_factory)
        @parse_command = parse_command
        @ast_path_factory = ast_path_factory
        @diff_factory = diff_factory
      end


      # Creates diff objects with meta information of changes between left and right commit
      # @param [MetaCommit::Git::Repo] repo
      # @param [String] left_commit commit id
      # @param [String] right_commit commit id
      # @return [Array<MetaCommit::Contracts::Diff>]
      def meta(repo, left_commit, right_commit)
        diffs = []
        commit_id_old = left_commit.oid
        commit_id_new = right_commit.oid
        repo.diff_with_optimized_lines(left_commit, right_commit) do |old_file_path, new_file_path, patch, line|
          old_file_content = repo.get_blob_at(commit_id_old, old_file_path, '')
          new_file_content = repo.get_blob_at(commit_id_new, new_file_path, '')

          old_file_ast = @parse_command.execute(old_file_path, old_file_content)
          next if old_file_ast.nil?
          new_file_ast = @parse_command.execute(new_file_path, new_file_content)
          next if new_file_ast.nil?

          old_ast_path = @ast_path_factory.create_contextual_node(old_file_ast, line.old_lineno)
          new_ast_path = @ast_path_factory.create_contextual_node(new_file_ast, line.new_lineno)

          created_diff = @diff_factory.create_diff_of_type(line.line_origin, {
              :line => line,
              :commit_id_old => commit_id_old,
              :commit_id_new => commit_id_new,
              :old_ast_path => old_ast_path,
              :new_ast_path => new_ast_path,
              :old_file_path => old_file_path,
              :new_file_path => new_file_path,
          })
          diffs.push(created_diff) unless created_diff.nil?
        end
        diffs
      end
    end
  end
end