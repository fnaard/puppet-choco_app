require 'spec_helper'
describe 'choco_app::source', :type => :define do

  context 'with an internal repository example' do
    let(:title) { 'internal' }
    let(:facts) { {
      :concat_basedir => 'C:\Windows\Temp',
    } }
    let(:params) { {
      :source_id => 'internal',
      :url => 'https://int-forge/',
      :disabled => 'false',
      :order => '80',
    } }

    # Adds a fragment to the config file
    it { should contain_concat__fragment('chocolatey source internal').with(
      :ensure  => 'present',
      :target  => 'chocolatey.config',
      :order   => '80',
      :content => /<source id="internal" value="https:\/\/int-forge\/"/,
    ) }

  end
end
