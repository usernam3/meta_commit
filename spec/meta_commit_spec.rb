require 'spec_helper'

describe MetaCommit do
  it 'has a version number' do
    expect(MetaCommit::VERSION).not_to be nil
  end
end
