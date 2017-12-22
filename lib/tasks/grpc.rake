namespace :grpc do
  desc 'Parse protos files defined in app/grpc/protos to output ruby codes.'
  task base: :environment do
    root_dir = Rails.root
    exec "grpc_tools_ruby_protoc -I #{root_dir}/app/grpc/protos --ruby_out=#{root_dir}/app/grpc/base --grpc_out=#{root_dir}/app/grpc/base #{root_dir}/app/grpc/protos/*.proto"
  end
end
