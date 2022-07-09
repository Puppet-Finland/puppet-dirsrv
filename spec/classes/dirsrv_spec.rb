# frozen_string_literal: true

require 'spec_helper'

describe 'dirsrv' do
  default_params = { 'manage_config'               => true,
                     'serveridentifier'            => 'vagrant',
                     'suffix'                      => 'dc=example,dc=org',
                     'rootdn'                      => 'cn=Directory Manager',
                     'rootdn_pwd'                  => 'vagrant123',
                     'allow_anonymous_access'      => 'on',
                     'self_sign_cert'              => true,
                     'self_sign_cert_valid_months' => 60, }

  let(:pre_condition) do
    <<-EOL
    include ::stdlib
    EOL
  end

  on_supported_os.each do |os, os_facts|
    context "defaults on #{os}" do
      let(:facts) { os_facts }
      let(:params) { default_params }

      it { is_expected.to compile }
    end
  end
end
