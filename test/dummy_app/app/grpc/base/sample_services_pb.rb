# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: sample.proto for package 'dummy_app'

require 'grpc'
require 'sample_pb'

module DummyApp
  module Sample
    class Service

      include GRPC::GenericService

      self.marshal_class_method = :encode
      self.unmarshal_class_method = :decode
      self.service_name = 'dummy_app.Sample'

      rpc :ping, PingRequest, PingResult
    end

    Stub = Service.rpc_stub_class
  end
end
