require 'spec_helper'

describe 'base boxes for the docker baseimages' do

  PLATFORMS = {
    ubuntu: ["14.04", "16.04"],
    amazon: ["2016.09"]
  }

  PLATFORMS.each_pair do |platform, versions|
    versions.each do |version|

      before(:all) do
        @tempdir = Dir.mktmpdir
        write_config @tempdir, vagrantfile_with_box_only(platform, version)

        # need to import the basebox once, see mitchellh/vagrant#5667
        basebox = "#{USER}/baseimage-#{platform}-#{version}"
        cmd = Mixlib::ShellOut.new("vagrant box add #{basebox}")
        result = cmd.run_command
        expect(result.stdout).to include "==> box: Successfully added box '#{basebox}' (v1.0.0) for 'docker'!"
        expect(result.status.exitstatus).to eq 0
      end

      after(:all) do
        FileUtils.rm_rf @tempdir
      end

      describe "#{USER}/baseimage-#{platform}-#{version}" do
        it 'comes up on  `vagrant up --provider docker`' do
          cmd = Mixlib::ShellOut.new("vagrant up --provider docker", :cwd => @tempdir)
          result = cmd.run_command
          expect(result.stdout).to include "==> default: Machine booted and ready!"
          expect(result.stderr).to match ""
          expect(result.status.exitstatus).to eq 0
        end
        it 'can be destroyed via `vagrant destroy`' do
          cmd = Mixlib::ShellOut.new("vagrant destroy -f", :cwd => @tempdir)
          result = cmd.run_command
          expect(result.stdout).to include "==> default: Deleting the container..."
          # destroying containers does not work on circleci
          unless ENV['CIRCLECI']
            expect(result.stderr).to match ""
            expect(result.status.exitstatus).to eq 0
          end
        end
      end

    end
  end
end
