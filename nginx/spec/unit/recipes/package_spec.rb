require 'spec_helper'

describe 'nginx::package' do
  before do
    stub_command('which nginx').and_return(nil)
  end

  shared_examples_for 'package install' do
    it 'includes the ohai_plugin recipe' do
      expect(chef_run).to include_recipe('nginx::ohai_plugin')
    end

    it 'includes the commons recipe' do
      expect(chef_run).to include_recipe('nginx::commons')
    end

    it 'enables the nginx service' do
      expect(chef_run).to enable_service('nginx')
    end

    it 'installs the nginx package' do
      expect(chef_run).to install_package('nginx')
    end

    it 'notifies a reload of ohai' do
      expect(chef_run.package('nginx')).to notify('ohai[reload_nginx]').to(:reload).immediately
    end
  end

  shared_examples_for 'nginx repo' do
    it 'includes the nginx repo recipe' do
      expect(chef_run).to include_recipe('nginx::repo')
    end
  end

  shared_examples_for 'distro repo' do
    it 'does not include the nginx repo recipe' do
      expect(chef_run).to_not include_recipe('nginx::repo')
    end

    it 'does not include yum-epel recipe' do
      expect(chef_run).to_not include_recipe('yum-epel')
    end
  end

  shared_examples_for 'epel repo' do
    it 'does not include the nginx repo recipe' do
      expect(chef_run).not_to include_recipe('nginx::repo')
    end

    it 'does include yum-epel recipe' do
      expect(chef_run).to include_recipe('yum-epel')
    end
  end

  context 'debian platform family' do
    context 'default attributes' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'ubuntu',
          version: '16.04'
        ).converge(described_recipe)
      end

      it 'installs the nginx package without modifiers' do
        expect(chef_run).to install_package('nginx').with({})
      end

      it_behaves_like 'package install'
      it_behaves_like 'nginx repo'
    end

    context 'repo_source set to distro' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04') do |node|
          node.override['nginx']['repo_source'] = 'distro'
        end.converge(described_recipe)
      end

      it_behaves_like 'package install'
      it_behaves_like 'distro repo'
    end
  end

  context 'rhel platform family' do
    context 'default attributes' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'centos',
          version: '6.9'
        ).converge(described_recipe)
      end

      it 'installs the nginx package with repo modifiers' do
        expect(chef_run).to install_package('nginx').with(
          options: ['--disablerepo=*', '--enablerepo=nginx']
        )
      end

      it_behaves_like 'package install'
      it_behaves_like 'nginx repo'
    end

    context 'repo_source set to distro' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(platform: 'centos', version: '6.9') do |node|
          node.override['nginx']['repo_source'] = 'distro'
        end.converge(described_recipe)
      end

      it 'installs the nginx package without modifiers' do
        expect(chef_run).to install_package('nginx').with({})
      end

      it_behaves_like 'package install'
      it_behaves_like 'distro repo'
    end
  end
end
