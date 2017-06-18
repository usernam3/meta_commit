require "parser/current"

module MetaCommit::Services
  class DiffIndexExaminer
    DIFF_OPTIONS = {:context_lines => 0, :ignore_whitespace => true}
    FILE_NOT_EXISTS_OID = '0000000000000000000000000000000000000000'

    def initialize(repo)
      @repo = repo
    end

    # region index_meta
    def index_meta
      diff = @repo.index_diff(DIFF_OPTIONS)

      diffs = MetaCommit::Models::Changes::Commit.new(@repo.repo.last_commit.oid, "staged")

      diff.deltas.zip(diff.patches).each do |delta, patch|
        diffs.push(examine_index_delta(delta, patch, @repo.repo.last_commit.oid))
      end
      diffs
    end

    def examine_index_delta(delta, patch, commit_id_old)
      old_file_path = delta.old_file[:path]
      new_file_path = delta.new_file[:path]

      diffs = MetaCommit::Models::Changes::File.new(old_file_path, new_file_path)

      return diffs unless (can_examine(old_file_path) and can_examine(new_file_path))

      old_file_content = @repo.get_blob_at(commit_id_old, old_file_path, '')
      # @TODO get content of staged changes only
      new_file_content = @repo.get_content_of(new_file_path, '')

      begin
        old_file_ast = Parser::CurrentRuby.parse(old_file_content)
        new_file_ast = Parser::CurrentRuby.parse(new_file_content)
      rescue Parser::SyntaxError
        return diffs
      end

      lines_to_walk = organize_lines(delta, patch)

      lines_to_walk.each do |line|
        old_ast_path = MetaCommit::Models::Factories::AstPathFactory.new.create_ast_path(old_file_ast, line.old_lineno)
        new_ast_path = MetaCommit::Models::Factories::AstPathFactory.new.create_ast_path(new_file_ast, line.new_lineno)

        factory = MetaCommit::Models::Factories::DiffFactory.new
        diff = factory.create_diff_of_type(line.line_origin, {
            :line => line,
            :commit_id_old => commit_id_old,
            :commit_id_new => 'workdir',
            :old_ast_path => old_ast_path,
            :new_ast_path => new_ast_path,
            :old_file_path => old_file_path,
            :new_file_path => new_file_path,
        })
        diffs.push(diff)
      end

      diffs
    end

    # endregion

    # region helpers
    def can_examine(file_path)
      file_path.end_with?('.rb')
    end
    def organize_lines(delta, patch)
      lines_to_walk = []
      # if whole file was changed examine one time only
      whole_file_changed = (delta.old_file[:oid] == FILE_NOT_EXISTS_OID) || (delta.new_file[:oid] == FILE_NOT_EXISTS_OID)
      skip_walking = false
      skip_next_line = false
      patch.hunks.each_with_index do |hunk|
        break if skip_walking
        hunk.lines.each_with_index do |line, line_index|
          break if skip_walking

          if skip_next_line
            skip_next_line = false
            next
          end

          next_line = hunk.lines[line_index + 1]
          is_replace_change = (line.deletion?) && (!next_line.nil? && next_line.addition?) && (line.old_lineno && next_line.new_lineno)

          line_to_walk = MetaCommit::Models::Line.new
          if is_replace_change
            line_to_walk.line_origin=:replace
            line_to_walk.old_lineno=line.old_lineno
            line_to_walk.new_lineno=next_line.new_lineno
          else
            line_to_walk.line_origin=line.line_origin
            line_to_walk.old_lineno=line.old_lineno
            line_to_walk.new_lineno=line.new_lineno
          end
          if is_replace_change
            skip_next_line = true
          end
          lines_to_walk.push(line_to_walk)

          skip_walking = true if whole_file_changed
        end
      end
      lines_to_walk
    end
    # endregion
  end
end