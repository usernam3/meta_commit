require 'rspec'

describe MetaCommit::Services::KeepAChangelogVerReportBuilder do
  describe '#build' do
    subject { MetaCommit::Services::KeepAChangelogVerReportBuilder.new('v 0.0.0', '1234-56789') }
    it 'prints version header' do
      expect(subject.build).to include('v 0.0.0')
      expect(subject.build).to include('1234-56789')
    end
  end
  describe '#add_to_added' do
    subject { MetaCommit::Services::KeepAChangelogVerReportBuilder.new('', '') }
    it 'adds added changes' do
      subject.add_to_added('change 1')
      expect(subject.build).to include('Added')
      expect(subject.build).to include('change 1')
    end
    it 'skips added changes when they are empty' do
      expect(subject.build).not_to include('Added')
    end
  end
  describe '#add_to_changed' do
    subject { MetaCommit::Services::KeepAChangelogVerReportBuilder.new('', '') }
    it 'adds changed changes' do
      subject.add_to_changed('change 1')
      expect(subject.build).to include('Changed')
      expect(subject.build).to include('change 1')
    end
    it 'skips changed changes when they are empty' do
      expect(subject.build).not_to include('Changed')
    end
  end
  describe '#add_to_deprecated' do
    subject { MetaCommit::Services::KeepAChangelogVerReportBuilder.new('', '') }
    it 'adds deprecated changes' do
      subject.add_to_deprecated('change 1')
      expect(subject.build).to include('Deprecated')
      expect(subject.build).to include('change 1')
    end
    it 'skips deprecated changes when they are empty' do
      expect(subject.build).not_to include('Deprecated')
    end
  end
  describe '#add_to_removed' do
    subject { MetaCommit::Services::KeepAChangelogVerReportBuilder.new('', '') }
    it 'adds removed changes' do
      subject.add_to_removed('change 1')
      expect(subject.build).to include('Removed')
      expect(subject.build).to include('change 1')
    end
    it 'skips removed changes when they are empty' do
      expect(subject.build).not_to include('Removed')
    end
  end
  describe '#add_to_fixed' do
    subject { MetaCommit::Services::KeepAChangelogVerReportBuilder.new('', '') }
    it 'adds fixed changes' do
      subject.add_to_fixed('change 1')
      expect(subject.build).to include('Fixed')
      expect(subject.build).to include('change 1')
    end
    it 'skips fixed changes when they are empty' do
      expect(subject.build).not_to include('Fixed')
    end
  end
  describe '#add_to_security' do
    subject { MetaCommit::Services::KeepAChangelogVerReportBuilder.new('', '') }
    it 'adds security changes' do
      subject.add_to_security('change 1')
      expect(subject.build).to include('Security')
      expect(subject.build).to include('change 1')
    end
    it 'skips security changes when they are empty' do
      expect(subject.build).not_to include('Security')
    end
  end
end