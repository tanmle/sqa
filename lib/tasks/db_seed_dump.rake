require 'active_support/core_ext/string/strip'

namespace :db do
  namespace :seed do
    task :dump => [:environment, :load_config] do
      desc 'LF - Create a db/seeds.rb file from the database'

      # get information from config/database.yml file
      erb = ERB.new(File.read('config/database.yml'))
      config = YAML.load(erb.result)[ENV['RAILS_ENV']]
      server = config['host']
      port = config['port']
      database = config['database']
      username = config['username']
      password = config['password']

      puts "Using '#{database}' database"

      seeds_path = File.join('db', 'seeds.rb').gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)

      command = "mysqldump #{database} -u #{username} -p#{password} --no-create-info --no-create-db --ignore-table=#{database}.schema_migrations  --ignore-table=#{database}.stations"
      output = `#{command}`

      ActiveRecord::Base.establish_connection(config)
      version = ActiveRecord::Base.connection.exec_query('select * from schema_migrations order by version desc limit 1').first.first[1]

      tables = output.scan(/(insert into `([^`]+).*)/i)
      puts " generated #{output.lines.size} lines for #{tables.size} tables"

      File.open(seeds_path, 'w') do |file|
        file.puts <<-INTERPOLATED_HEREDOC.strip_heredoc
          # encoding: UTF-8
          # This file is auto-generated from the current state of the database.
          #
          # #{version} database version used
          # #{tables.size} tables had data

          puts 'Seeding #{tables.size} tables for database version #{version}'

        INTERPOLATED_HEREDOC

        file.puts <<-'HEREDOC'.strip_heredoc
          @connection = ActiveRecord::Base.connection
          def insert_data(number, table_name, insert_sql)
            before = @connection.exec_query("select count(1) from #{table_name}").first.first[1].to_i
            @connection.execute insert_sql
            after = @connection.exec_query("select count(1) from #{table_name}").first.first[1].to_i
            puts "#{number}.\t#{after - before}\t#{after}\t#{table_name}"
          end

          puts "#\tadded\ttotal\ttable"

        HEREDOC

        tables.each_with_index do |table, index|
          file.puts <<-INTERPOLATED_HEREDOC.strip_heredoc
            insert_data #{index + 1}, '#{table[1]}', <<-'HEREDOC'
            #{table[0]}
            HEREDOC

          INTERPOLATED_HEREDOC
        end

        file.puts "puts 'done!'"
      end
    end
  end
end
