require "test_helper"

require 'sample_services_pb'

class GrpcForRailsTest < Minitest::Test
  def test_fork_grpc_server_and_call_it
    server_process = Process.fork do
      Dir.chdir 'test/dummy_app'
      exec 'bundle exec grpc_server'
    end
    sleep 2

    begin
      stub = DummyApp::Sample::Stub.new('localhost:3011', :this_channel_is_insecure)
      message = stub.ping(DummyApp::PingRequest.new(message: 'Hi!')).message
      assert_equal 'Get Hi!', message
    ensure
      Process.kill 'TERM', server_process
      Process.wait
    end
  end

  def test_fork_grpc_server_with_pid
    assert true
  end
end
