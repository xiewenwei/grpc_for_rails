require 'grpc'
require 'logger'

module GRPC
  def self.logger
    @logger ||= Logger.new($stdout)
  end
end

module GrpcForRails
  class Server
    attr_reader :options

    EXECUTABLES = ['bin/rails', 'script/rails']

    def initialize(options)
      @options = options
      ENV['RAILS_ENV'] = @options[:env]

      # daemonization will change CWD so expand relative paths now
      options[:logfile] = File.expand_path(logfile) if logfile?
      options[:pidfile] = File.expand_path(pidfile) if pidfile?
    end

    def run
      check_pid
      daemonize if daemonize?
      write_pid

      if logfile?
        redirect_output
      elsif daemonize?
        suppress_output
      end
      startup
    end

    private

    def startup
      load_rails_environment!

      @server ||= GRPC::RpcServer.new pool_size: @options[:pool_size]
      @server.add_http2_port "#{@options[:host]}:#{@options[:port]}", :this_port_is_insecure
      services.each { |service| @server.handle service }
      begin
        @server.run
      rescue SignalException => e
        GRPC.logger.info "shutdown server..."
        @server.stop
        force_delete_pidfile!
      end
    end

    def daemonize?
      options[:daemonize]
    end

    def logfile
      options[:logfile]
    end

    def pidfile
      options[:pidfile]
    end

    def logfile?
      !logfile.nil?
    end

    def pidfile?
      !pidfile.nil?
    end

    def write_pid
      if pidfile?
        begin
          File.open(pidfile, ::File::CREAT | ::File::EXCL | ::File::WRONLY){|f| f.write("#{Process.pid}") }
          at_exit { File.delete(pidfile) if File.exists?(pidfile) }
        rescue Errno::EEXIST
          check_pid
          retry
        end
      end
    end

    def check_pid
      if pidfile?
        case pid_status(pidfile)
        when :running, :not_owned
          puts "A server is already running. Check #{pidfile}"
          exit(1)
        when :dead
          File.delete(pidfile)
        end
      end
    end

    def force_delete_pidfile!
      if pidfile?
        File.delete(pidfile) rescue nil
      end
    end

    def pid_status(pidfile)
      return :exited unless File.exists?(pidfile)
      pid = ::File.read(pidfile).to_i
      return :dead if pid == 0
      Process.kill(0, pid)      # check process status
      :running
    rescue Errno::ESRCH
      :dead
    rescue Errno::EPERM
      :not_owned
    end

    def daemonize
      exit if fork
      Process.setsid
      exit if fork
      #Dir.chdir "/"
    end

    def redirect_output
      FileUtils.mkdir_p(File.dirname(logfile), mode: 0755)
      FileUtils.touch logfile
      File.chmod(0644, logfile)
      $stderr.reopen(logfile, 'a')
      $stdout.reopen($stderr)
      $stdout.sync = $stderr.sync = true
    end

    def suppress_output
      $stderr.reopen('/dev/null', 'a')
      $stdout.reopen($stderr)
    end

    def services
      Dir["#{Rails.root}/app/grpc/services/**/*.rb"].each { |f| require f }

      Dir["#{Rails.root}/app/grpc/services/*.rb"].map do |file|
        class_name = file.split('/').last.sub(/\.rb$/, '').camelize
        Object.const_get class_name
      end
    end

    def load_rails_environment!
      loop do
        if exe = find_executable
          Object.const_set(:APP_PATH, File.expand_path('config/application', Dir.pwd))
          require File.expand_path('../environment', APP_PATH)
          break
        end

        raise 'You are not in Rails project' if Pathname.new(Dir.pwd).root?

        # Otherwise keep moving upwards in search of an executable.
        Dir.chdir('..')
      end
    end

    def find_executable
      EXECUTABLES.find { |exe| File.file?(exe) }
    end
  end
end
