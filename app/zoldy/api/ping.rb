module Zoldy
  class API::Ping < Grape::API
    helpers do
      include AutoLogger::Named.new(name: :ping_api)
    end

    format :json
    default_format :json
    formatter :json, PrettyJSONFormatter

    helpers do
      def detailed_threads_count
        "#{Thread.list.select { |t| t.status == 'run' }.count}/#{Thread.list.count}"
      end
    end

    desc 'ping node'
    get '/' do
      logger.info 'Get ping'
      present(
        version:     Zoldy::VERSION.to_s,
        alias:       Settings.node_alias,
        network:     Settings.network,
        protocol:    Zoldy::Middleware::PROTOCOL,
        score:       Zoldy.app.score.to_h,
        pid:         Process.pid,
        processes:   1, # TODO get it from Puma wokers size
        cpus:        Concurrent.processor_count,
        memory:      GetProcessMem.new.bytes.to_i,
        platform:    RUBY_PLATFORM,
        load:        Usagewatch.uw_load.to_f,
        threads:     detailed_threads_count,
        wallets:     Zoldy.app.wallets.count,
        remotes:     Zoldy.app.remotes.count,
        nscore:      Zoldy.app.remotes.nscore,
        #farm: Zoldy.Settings.farm.to_json,
        #entrance: Zoldy.Settings.entrance.to_json,
        date:        Time.now.utc.iso8601,
        hours_alive: (Zoldy.app.uptime / (60 * 60)).round(2),
        home:        Settings.home
      )
    end
  end
end
