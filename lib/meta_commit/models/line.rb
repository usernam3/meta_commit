module MetaCommit::Models
  class Line
    attr_accessor :line_origin, :old_lineno, :new_lineno, :content_offset

    # Compares old_lineno line of old_file_content and new_lineno of new_file_content
    # @param [String] old_file_content
    # @param [String] new_file_content
    # @return [Numeric] index of (first different)|(last common) symbol in string
    def compute_column(old_file_content, new_file_content)
      return if old_file_content.empty? || new_file_content.empty?
      return if old_lineno == -1 || new_lineno == -1

      old_line = old_file_content.split("\n")[old_lineno - 1]
      new_line = new_file_content.split("\n")[new_lineno - 1]

      return if old_line.empty? || new_line.empty?

      old_line.each_char.with_index do |char, index|
        return index if (char != new_line[index])
      end

      old_line.length
    end
  end
end