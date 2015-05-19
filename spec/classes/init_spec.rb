require 'spec_helper'
describe 'choco_app' do

  context 'with defaults for all parameters' do
    it { should contain_class('choco_app') }
  end
end
