module MetaCommit::Plugin::Ruby
  # Package interface
  class Locator
    # @return [Array] parser classes that package provides
    def parsers
      [
          MetaCommit::Plugin::Ruby::Parsers::Ruby,
      ]
    end

    # @return [Array] diff classes that package provides
    def diffs
      [
          MetaCommit::Plugin::Ruby::Diffs::InitializeChanged,
          MetaCommit::Plugin::Ruby::Diffs::ClassCreation,
          MetaCommit::Plugin::Ruby::Diffs::ClassDeletion,
          MetaCommit::Plugin::Ruby::Diffs::ClassRename,
          MetaCommit::Plugin::Ruby::Diffs::MethodCreation,
          MetaCommit::Plugin::Ruby::Diffs::MethodDeletion,
          MetaCommit::Plugin::Ruby::Diffs::ChangesInMethod,
          MetaCommit::Plugin::Ruby::Diffs::ModuleCreation,
          MetaCommit::Plugin::Ruby::Diffs::ModuleDeletion,
          MetaCommit::Plugin::Ruby::Diffs::ModuleRename,
          MetaCommit::Plugin::Ruby::Diffs::Diff,
      ]
    end
  end
end