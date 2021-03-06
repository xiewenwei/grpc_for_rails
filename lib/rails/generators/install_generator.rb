require 'rails/generators/base'

module Grpc
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path '../templates', __FILE__
    desc "Install grpc_server.yml file to your application."

    def mkdirs
      empty_directory 'app/grpc/services'
      empty_directory 'app/grpc/base'
      empty_directory 'app/grpc/protos'
    end

    def copy_config
      template 'grpc_server.yml', 'config/grpc_server.yml'
    end
  end
end
