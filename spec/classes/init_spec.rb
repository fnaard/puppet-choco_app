require 'spec_helper'
describe 'choco_app' do

  context 'with defaults for all parameters' do
    let(:facts) {{
      :concat_basedir => 'C:\Windows\Temp',
    }}

    # Bare basics
    it { should contain_class('choco_app') }

    # Tries to install
    it { should contain_exec('install-choco') }

    # Sets up the config file
    it { should contain_concat('chocolatey.config') }

    it { should contain_concat__fragment('chocolatey.config top') }

    it { should contain_concat__fragment('chocolatey.config bottom') }

  end
end
