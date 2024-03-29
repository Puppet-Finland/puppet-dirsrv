# frozen_string_literal: true

require 'spec_helper'

describe 'dirsrv::backup' do
  let(:title) { 'namevar' }
  let(:params) do
    { 'instance'      => 'vagrant',
      'bind_password' => 'vagrant123' }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
