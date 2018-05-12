module MetaCommit::Message
  module Commands
    class DiffIndexExaminer
      # @param [MetaCommit::Services::Parse] parse_command
      # @param [MetaCommit::Factories::ContextualAstNodeFactory] ast_path_factory
      # @param [MetaCommit::Factories::DiffFactory] diff_factory
      # @param [MetaCommit::Factories::DiffFactory] diff_lines_provider
      def initialize(parse_command, ast_path_factory, diff_factory, diff_lines_provider)
        @parse_command = parse_command
        @ast_path_factory = ast_path_factory
        @diff_factory = diff_factory
        @diff_lines_provider = diff_lines_provider
      end

      # Creates diff objects with meta information of changes in index staged files
      # @param [MetaCommit::Git::Repo] repo
      # @return [Array<MetaCommit::Contracts::Diff>]
      def index_meta(repo)
        diffs = MetaCommit::Models::Changes::Commit.new(repo.last_commit_oid, 'staged')
        repo_diff = repo.index_diff(MetaCommit::Git::Repo::INDEX_DIFF_OPTIONS)
        diff_lines = @diff_lines_provider.from(repo_diff)
        diff_lines.each do |(old_file_path, new_file_path, patch, line)|
          commit_id_old = repo.last_commit_oid
          commit_id_new = 'staged'

          old_file_content = repo.get_blob_at(commit_id_old, old_file_path, '')
          new_file_content = repo.get_content_of(new_file_path, '')

          old_file_ast = @parse_command.execute(old_file_path, old_file_content)
          next if old_file_ast.nil?
          new_file_ast = @parse_command.execute(new_file_path, new_file_content)
          next if new_file_ast.nil?

          column_where_changes_start = line.compute_column(old_file_content, new_file_content)

          old_file_deleted = (patch.delta.new_file[:oid] == MetaCommit::Git::Repo::FILE_NOT_EXISTS_OID)
          old_line_number = (old_file_deleted) ? (MetaCommit::Factories::ContextualAstNodeFactory::WHOLE_FILE) : (line.old_lineno)
          old_contextual_ast = @ast_path_factory.create_contextual_node(old_file_ast, old_line_number)

          new_file_created = (patch.delta.old_file[:oid] == MetaCommit::Git::Repo::FILE_NOT_EXISTS_OID)
          new_line_number = (new_file_created) ? (MetaCommit::Factories::ContextualAstNodeFactory::WHOLE_FILE) : (line.new_lineno)
          new_contextual_ast = @ast_path_factory.create_contextual_node(new_file_ast, new_line_number)

          created_diff = @diff_factory.create_diff({
              :line => line,
              :column => column_where_changes_start,
              :commit_id_old => commit_id_old,
              :commit_id_new => commit_id_new,
              :old_contextual_ast => old_contextual_ast,
              :new_contextual_ast => new_contextual_ast,
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