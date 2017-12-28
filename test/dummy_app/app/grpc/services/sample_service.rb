require 'sample_services_pb'

class SampleService < DummyApp::Sample::Service
  def ping(req, _)
    msg = "Get #{req.message}"
    DummyApp::PingResult.new message: msg
  end
end
