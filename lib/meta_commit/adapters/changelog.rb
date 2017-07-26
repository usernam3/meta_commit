module MetaCommit::Adapters
  class Changelog
    VERSION_DELIMITER="\n\n\n"
    VERSION_HEADER_REGEX = /(## \[.*?\] - \d{4}-\d{2}-\d{2})/m

    attr_accessor :path, :filename, :tag, :date

    def initialize(path, filename, tag, date)
      @path=path
      @filename=filename
      @tag=tag
      @date=date
    end

    def changelog_path
      File.join(@path, @filename)
    end

    def changelog_message_builder(version, date)
      MetaCommit::Services::KeepAChangelogVerReportBuilder.new(version, date)
    end

    def write_repository_change_chunk(repository, repository_changes)
      repository_changes.each do |commit_changes|
        message_builder = changelog_message_builder(@tag, @date)
        commit_changes.each do |file_changes|
          unique_file_changes = file_changes.changes.uniq { |change| change.to_s }
          unique_file_changes.each do |diff|
            message_builder.add_to_added(diff.string_representation) if diff.type_addition?
            message_builder.add_to_removed(diff.string_representation) if diff.type_deletion?
            message_builder.add_to_changed(diff.string_representation) if diff.type_replace?
          end
        end
        prepend_to_changelog(message_builder.build)
      end
    end

    # @param [String] text
    # @return [String]
    def prepend_to_changelog(text)
      current_changelog_content = read_from_changelog
      current_changelog_parts = current_changelog_content.split(VERSION_HEADER_REGEX)

      if starts_with_description(current_changelog_parts)
        new_changelog_parts = [current_changelog_parts[0]] + [text, "#{VERSION_DELIMITER}"] + current_changelog_parts[1..-1]
      else
        new_changelog_parts = [text, "#{VERSION_DELIMITER}"] + current_changelog_parts
      end

      write_to_changelog(new_changelog_parts.join)
    end
    private :prepend_to_changelog

    # @return [String] changelog file content
    def read_from_changelog
      File.read(changelog_path)
    end
    private :read_from_changelog

    # @param [String] text content to write to changelog file
    # @return [String]
    def write_to_changelog(text)
      File.open(changelog_path, 'w').write(text)
      text
    end
    private :write_to_changelog

    # @param [Array<String>] changelog_parts content sections from changelog
    # @return [Bool]
    def starts_with_description(changelog_parts)
      changelog_parts[0].match(VERSION_HEADER_REGEX).nil?
    end
    private :starts_with_description
  end
end