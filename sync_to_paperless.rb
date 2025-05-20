require 'time'

FILE_PATH='/Volumes/SharedFiles/'
TIMESTAMP_PATH='/Users/rbanerjee/paperless/last_run_timestamp.txt'
FILE_TYPES = [ "*.pdf","*.doc","*.docx","*.xls","*.xlsx","*.txt"]
SCP_USER = 'paperless'
SCP_HOST = 'paperless-ngx.lan'
SCP_REMOTE_PATH = '/opt/paperless/consume/'

def get_all_files
  all_files = []
  Dir.chdir(FILE_PATH)

  FILE_TYPES.each do |ft|
    path = File.join"**", ft
    new_files = Dir.glob(path)
    all_files << new_files
  end
  all_files.flatten
end

def scp_files(files)
  if files.nil? or files.empty?
    puts "No files needing sync. Doing nothing."
    return
  end
  scp_cmd_suffix = "#{SCP_USER}@#{SCP_HOST}:#{SCP_REMOTE_PATH}"
  files.each do |f|
    system ("scp \"#{FILE_PATH}/#{f}\" #{scp_cmd_suffix}")
  end
end

def write_timestamp
  File.open(TIMESTAMP_PATH, "w") { |f| f.write "#{Time.now}\n" }
  puts "Wrote timestamp to #{TIMESTAMP_PATH}"
end

def get_last_timestamp
  timestamp_str = File.read(TIMESTAMP_PATH)
  timestamp = Time.parse(timestamp_str)
  puts "Script last ran at #{timestamp}."
  timestamp
end

def filter_by_timestamp(all_files, timestamp)
  filtered = []
  all_files.each do |f|
    mod_time = File.stat(f).mtime
    if mod_time > timestamp
      filtered << f
      puts "File #{f} was modified on #{mod_time}, more recent than last run at #{timestamp}. Will scp it."
    end

  end
  filtered
end

begin
  all_files = get_all_files
  last_run_timestamp = get_last_timestamp
  files_to_copy = filter_by_timestamp(all_files, last_run_timestamp)

rescue Exception => e
    puts "Exception thrown!"
    puts e.message
  ensure
    scp_files(files_to_copy)
    write_timestamp
end

