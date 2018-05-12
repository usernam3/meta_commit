module MetaCommit::Changelog
  module Formatters
    # Class builds messages with release changes according to [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) specification
    # @attr [String] version
    # @attr [String] date
    # @attr [Array<String>] added_changes Changes from "Added" section
    # @attr [Array<String>] changed_changes Changes from "Changed" section
    # @attr [Array<String>] deprecated_changes Changes from "Deprecated" section
    # @attr [Array<String>] removed_changes Changes from "Removed" section
    # @attr [Array<String>] fixed_changes Changes from "Fixed" section
    # @attr [Array<String>] security_changes Changes from "Security" section
    class KeepAChangelogVerReportBuilder
      extend Forwardable
      # attr_reader :version, :date
      attr_reader :added_changes, :changed_changes, :deprecated_changes, :removed_changes, :fixed_changes, :security_changes

      def_delegator :@added_changes, :push, :add_to_added
      def_delegator :@changed_changes, :push, :add_to_changed
      def_delegator :@deprecated_changes, :push, :add_to_deprecated
      def_delegator :@removed_changes, :push, :add_to_removed
      def_delegator :@fixed_changes, :push, :add_to_fixed
      def_delegator :@security_changes, :push, :add_to_security

      def initialize(version, date)
        @version=version
        @date=date
        @added_changes, @changed_changes, @deprecated_changes, @removed_changes, @fixed_changes, @security_changes = [], [], [], [], [], []
      end

      # @return [String] Version header
      def version_entry
        "## [#{@version}] - #{@date}"
      end

      private :version_entry

      # @return [String] List of changes with type header
      def changes_group_entry(type, changes)
        header = ["### #{type}"]
        list = changes.map { |change| "- #{change}" }
        ([header] + list).uniq.join("\n")
      end

      private :changes_group_entry

      # @return [String] List of added changes with header
      def added_changes_group_entry
        changes_group_entry('Added', @added_changes)
      end

      private :added_changes_group_entry

      # @return [String] List of changed changes with header
      def changed_changes_group_entry
        changes_group_entry('Changed', @changed_changes)
      end

      private :changed_changes_group_entry

      # @return [String] List of deprecated changes with header
      def deprecated_changes_group_entry
        changes_group_entry('Deprecated', @deprecated_changes)
      end

      private :deprecated_changes_group_entry

      # @return [String] List of removed changes with header
      def removed_changes_group_entry
        changes_group_entry('Removed', @removed_changes)
      end

      private :removed_changes_group_entry

      # @return [String] List of fixed changes with header
      def fixed_changes_group_entry
        changes_group_entry('Fixed', @fixed_changes)
      end

      private :fixed_changes_group_entry

      # @return [String] List of security changes with header
      def security_changes_group_entry
        changes_group_entry('Security', @security_changes)
      end

      private :security_changes_group_entry

      # @return [String] Report with version changes
      def build
        result = [version_entry]
        result += [added_changes_group_entry] unless @added_changes.empty?
        result += [changed_changes_group_entry] unless @changed_changes.empty?
        result += [deprecated_changes_group_entry] unless @deprecated_changes.empty?
        result += [removed_changes_group_entry] unless @removed_changes.empty?
        result += [fixed_changes_group_entry] unless @fixed_changes.empty?
        result += [security_changes_group_entry] unless @security_changes.empty?
        result.join("\n")
      end
    end
  end
end