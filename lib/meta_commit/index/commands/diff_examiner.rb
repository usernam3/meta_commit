module MetaCommit::Index
  module Commands
    class DiffExaminer
      # @param [MetaCommit::Services::Parse] parse_command
      # @param [MetaCommit::Models::Factories::ContextualAstNodeFactory] ast_path_factory
      # @param [MetaCommit::Models::Factories::DiffFactory] diff_factory
      def initialize(parse_command, ast_path_factory, diff_factory)
        @parse_command = parse_command
        @ast_path_factory = ast_path_factory
        @diff_factory = diff_factory
      end

      # Creates diff objects with meta information of changes in repository commits
      # @param [MetaCommit::Git::Repo] repo
      def meta(repo)
        repo_changes = MetaCommit::Models::Changes::Repository.new(repo.path)
        repo.walk_by_commits do |left_commit, right_commit|
          commit_changes = MetaCommit::Models::Changes::Commit.new(left_commit.oid, right_commit.oid)
          diffs = examine_diff(repo, left_commit, right_commit)
          commit_changes.push_changes(diffs)
          repo_changes.push(commit_changes)
        end
        repo_changes
      end

      # @return [Array<MetaCommit::Models::Diffs::Diff>]
      def examine_diff(repo, left_commit, right_commit)
        diffs = []
        repo.diff_with_optimized_lines(left_commit, right_commit) do |old_file_path, new_file_path, patch, line|
          old_file_content = repo.get_blob_at(left_commit.oid, old_file_path, '')
          new_file_content = repo.get_blob_at(right_commit.oid, new_file_path, '')

          old_file_ast = @parse_command.execute(old_file_path, old_file_content)
          next if old_file_ast.nil?
          new_file_ast = @parse_command.execute(new_file_path, new_file_content)
          next if new_file_ast.nil?

          old_ast_path = @ast_path_factory.create_ast_path(old_file_ast, line.old_lineno)
          new_ast_path = @ast_path_factory.create_ast_path(new_file_ast, line.new_lineno)

          created_diff = @diff_factory.create_diff_of_type(line.line_origin, {
              :line => line,
              :commit_id_old => left_commit.oid,
              :commit_id_new => right_commit.oid,
              :old_ast_path => old_ast_path,
              :new_ast_path => new_ast_path,
              :old_file_path => old_file_path,
              :new_file_path => new_file_path,
          })
          diffs.push(created_diff) unless created_diff.nil?
        end
        diffs
      end

      private :examine_diff
    end
  end
end