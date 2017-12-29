require "test_helper"

require 'rails/generators/install_generator'

class InstallGeneratorTest < ::Rails::Generators::TestCase
  tests Grpc::InstallGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))
  setup :prepare_destination
  teardown :cleanup_destination

  def setup
    run_generator
  end

  def cleanup_destination
    tmp_dir = File.expand_path("../tmp", File.dirname(__FILE__))
    FileUtils.rm_rf tmp_dir
  end

  def test_generates_dirs
    assert_directory "app/grpc"
    assert_directory "app/grpc/base"
    assert_directory "app/grpc/protos"
    assert_directory "app/grpc/services"
  end

  def test_generates_config
    assert_file "config/grpc_server.yml", /port: 3011/
  end
end
