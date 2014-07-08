require 'yaml'
require 'highline/import'
require 'open-uri'

module Devkit
  class Core
    class << self
      def init!(options)
        if check_if_devkit_file_exists?
          if agree('.devkit file already exist.You want to over ride existing file? (y/n)', true)
            clear_existing_devkit_file
            puts 'Cleared existing identities in .devkit file'
          else
            puts 'No changes made to the existing file.'
          end
        else
          puts 'Creating .devkit file in your home directory. Try devkit --add for adding more identities to devkit.'
          File.new(DEVKIT_FILE_PATH, 'w')

        end
      end

      def fetch!(options)
        archive_url = options[:archive_url]
        fetch_devkit_config_from_remote(archive_url)
        File.open(DEVKIT_REMOTE_FILE_PATH, 'w') { |file| file.write(archive_url) }
      end

      def fetch_devkit_config_from_remote(archive_url)
        puts "Fetching .devkit from: #{archive_url}"
        config_from_remote = YAML.load(open(archive_url).read)
        File.open(DEVKIT_FILE_PATH,'w').write(config_from_remote.to_yaml)

        url_base = File.dirname(archive_url)

        config_from_remote.each do |nick_name,config_data|
          ssh_id = config_data['SSH Identity']
          key_url = "#{url_base}/#{ssh_id}"

          puts "Fetching key for #{nick_name} from #{key_url}"

          fetch_private_key(key_url,ssh_id)
        end

      end

      def fetch_private_key(key_url,key_name)
        key = open(key_url).read
        key_path = File.join(Dir.home,'.ssh',key_name)
        File.open(key_path,'w').write(key)
      end

      def update!()
        if check_if_remote_file_exists?
          archive_url = File.open(DEVKIT_REMOTE_FILE_PATH, 'r').read
          fetch_devkit_config_from_remote(archive_url)
        else
          puts "Remote file doesn't exist. Try devkit --init --url <devkit_url> to initialise with a shared config"
        end
      end



      def purge!
        if check_if_devkit_file_exists? && agree('Are you sure you want to clear existing devkit file? (y/n)', true)
          clear_existing_devkit_file
        end
      end

      def status
        Devkit::GitIdentity::status
        Devkit::SshIdentity::status
      end

      def clear_existing_devkit_file
        File.truncate(DEVKIT_FILE_PATH, 0)
      end

      def identities
        if check_if_devkit_file_exists?
          YAML.load_file(DEVKIT_FILE_PATH) || {}
        else
          {}
        end
      end

      def check_if_devkit_file_exists?
        File.exists?(DEVKIT_FILE_PATH)
      end

      def check_if_remote_file_exists?
        File.exists?(DEVKIT_REMOTE_FILE_PATH)
      end
    end
  end
end
