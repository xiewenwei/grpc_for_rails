require "test_helper"

class GrpcBaseTaskTest < ActiveSupport::TestCase
  setup do
    require 'rake'
    copy_proto_file
    DummyApp::Application.load_tasks
    Process.fork { Rake::Task['grpc:base'].invoke }
    sleep 2
  end

  teardown do
    cleanup_files
  end

  test "generate_codes_for_proto" do
    assert File.exists?("#{base_dir}/base/grpc_test_pb.rb")
    assert File.exists?("#{base_dir}/base/grpc_test_services_pb.rb")
  end

  private

  def copy_proto_file
    origin_file = File.expand_path("./grpc_test.proto", File.dirname(__FILE__))
    FileUtils.copy origin_file, "#{base_dir}/protos"
  end

  def cleanup_files
    FileUtils.rm "#{base_dir}/base/grpc_test_pb.rb", force: true
    FileUtils.rm "#{base_dir}/base/grpc_test_services_pb.rb", force: true
    FileUtils.rm "#{base_dir}/protos/grpc_test.proto", force: true
  end

  def base_dir
    @proto_dir ||= File.expand_path("./dummy_app/app/grpc", File.dirname(__FILE__))
  end
end
