# paperless-sync
A script that helps selectively sync files into [paperless](https://docs.paperless-ngx.com/)' consume folder. It finds 
files that have been modified since the last sync, so that it can avoid transferring duplicate files for paperless 
consumption. 

Written in Ruby

It will:
1. Look up when this script last ran. It stores a timestamp in a txt file.
2. Find all files in the File Path specified that have been modifiend since the timestamp
3. SCP each of those files to the consume folder on the paperless server.

## Usage
1. Edit the .rb file to specify your own values:

Configurable Values:

```
FILE_PATH='[Path to the local files to sync]'
TIMESTAMP_PATH='[script will create a txt file at this writable path]'
FILE_TYPES = [ "*.pdf","*.doc","*.docx","*.xls","*.xlsx","*.txt"]
SCP_USER = 'paperless'
SCP_HOST = '192.168.1.199'
SCP_REMOTE_PATH = '/opt/paperless/consume/'
```

2. If not already setup, use [ssh-copy-id](https://www.ssh.com/academy/ssh/copy-id)  to copy your SSH key to the paperless host.
3. Run the script like: *ruby sync_to_paperless.rb*

### Dependencies

* [Ruby 2.7*](https://www.ruby-lang.org/en/downloads/)+
* SCP command-line utility that usually comes with SSH
* Ability to SCP into paperless host. Passwordless SSH usage is very useful here.