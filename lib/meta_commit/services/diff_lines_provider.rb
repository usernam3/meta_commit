module MetaCommit::Services
  class DiffLinesProvider

    # @param [Rugged::Diff::Delta] diff
    # @return [Array<Array>]
    def from(diff)
      result = []
      diff.deltas.zip(diff.patches).each do |delta, patch|
        lines = organize_lines(delta, patch)
        lines.each do |line|
          result.push [delta.old_file[:path], delta.new_file[:path], patch, line]
        end
      end
      result
    end

    # @param [Object] delta
    # @param [Object] patch
    # @return [Array<MetaCommit::Models::Line>]
    def organize_lines(delta, patch)
      lines_to_walk = []
      # if whole file was changed examine one time only
      whole_file_changed = (delta.old_file[:oid] == MetaCommit::Git::Repo::FILE_NOT_EXISTS_OID) || (delta.new_file[:oid] == MetaCommit::Git::Repo::FILE_NOT_EXISTS_OID)
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
            line_to_walk.line_origin = :replace
            line_to_walk.old_lineno = line.old_lineno
            line_to_walk.new_lineno = next_line.new_lineno
            line_to_walk.content_offset = next_line.content_offset
          else
            line_to_walk.line_origin = line.line_origin
            line_to_walk.old_lineno = line.old_lineno
            line_to_walk.new_lineno = line.new_lineno
            line_to_walk.content_offset = line.content_offset
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

    protected :organize_lines
  end
end