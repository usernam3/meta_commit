module MetaCommit::Message
  module Commands
    class DiffIndexExaminer
      # @param [MetaCommit::Services::Parse] parse_command
      # @param [MetaCommit::Models::Factories::AstPathFactory] ast_path_factory
      # @param [MetaCommit::Models::Factories::DiffFactory] diff_factory
      def initialize(parse_command, ast_path_factory, diff_factory)
        @parse_command = parse_command
        @ast_path_factory = ast_path_factory
        @diff_factory = diff_factory
      end

      # Creates diff objects with meta information of changes in index staged files
      # @param [MetaCommit::Git::Repo] repo
      # @return [Array<MetaCommit::Models::Diffs::Diff>]
      def index_meta(repo)
        diffs = MetaCommit::Models::Changes::Commit.new(repo.last_commit_oid, 'staged')
        repo.index_diff_with_optimized_lines do |old_file_path, new_file_path, patch, line|
          commit_id_old = repo.last_commit_oid
          commit_id_new = 'staged'

          old_file_content = repo.get_blob_at(commit_id_old, old_file_path, '')
          new_file_content = repo.get_content_of(new_file_path, '')

          old_file_ast = @parse_command.execute(old_file_path, old_file_content)
          next if old_file_ast.nil?
          new_file_ast = @parse_command.execute(new_file_path, new_file_content)
          next if new_file_ast.nil?

          old_ast_path = @ast_path_factory.create_ast_path(old_file_ast, line.old_lineno)
          new_ast_path = @ast_path_factory.create_ast_path(new_file_ast, line.new_lineno)

          created_diff = @diff_factory.create_diff_of_type(line.line_origin, {
              :line => line,
              :commit_id_old => commit_id_old,
              :commit_id_new => commit_id_new,
              :old_ast_path => old_ast_path,
              :new_ast_path => new_ast_path,
              :old_file_path => old_file_path,
              :new_file_path => new_file_path,
          })
          diffs.push(created_diff)
        end
        diffs
      end
    end
  end
end