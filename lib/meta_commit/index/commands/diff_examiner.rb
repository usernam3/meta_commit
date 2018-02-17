module MetaCommit::Index
  module Commands
    class DiffExaminer
      # @param [MetaCommit::Services::Parse] parse_command
      # @param [MetaCommit::Factories::ContextualAstNodeFactory] ast_path_factory
      # @param [MetaCommit::Factories::DiffFactory] diff_factory
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

      # @return [Array<MetaCommit::Contracts::Diff>]
      def examine_diff(repo, left_commit, right_commit)
        diffs = []
        repo.diff_with_optimized_lines(left_commit, right_commit) do |old_file_path, new_file_path, patch, line|
          old_file_content = repo.get_blob_at(left_commit.oid, old_file_path, '')
          new_file_content = repo.get_blob_at(right_commit.oid, new_file_path, '')

          old_file_ast = @parse_command.execute(old_file_path, old_file_content)
          next if old_file_ast.nil?
          new_file_ast = @parse_command.execute(new_file_path, new_file_content)
          next if new_file_ast.nil?

          column_where_changes_start = line.compute_column(old_file_content, new_file_content)

          old_file_deleted = (patch.delta.new_file[:oid] == MetaCommit::Git::Repo::FILE_NOT_EXISTS_OID)
          old_line_number = (old_file_deleted) ? (MetaCommit::Factories::ContextualAstNodeFactory::WHOLE_FILE) : (line.old_lineno)
          old_contextual_ast = @ast_path_factory.create_contextual_node(old_file_ast, old_line_number, column_where_changes_start)

          new_file_created = (patch.delta.old_file[:oid] == MetaCommit::Git::Repo::FILE_NOT_EXISTS_OID)
          new_line_number = (new_file_created) ? (MetaCommit::Factories::ContextualAstNodeFactory::WHOLE_FILE) : (line.new_lineno)
          new_contextual_ast = @ast_path_factory.create_contextual_node(new_file_ast, new_line_number, column_where_changes_start)

          created_diff = @diff_factory.create_diff({
              :line => line,
              :column => column_where_changes_start,
              :commit_id_old => left_commit.oid,
              :commit_id_new => right_commit.oid,
              :old_contextual_ast => old_contextual_ast,
              :new_contextual_ast => new_contextual_ast,
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