require 'parse-ruby-client'
require 'byebug'
require 'OptionParser'
require 'mime-types'

# USAGE: ruby parse_upload.rb filenames -class class_name -col column_name

Parse.init application_id: ENV['PARSE_APP_ID'],
           api_key: ENV['PARSE_API_KEY'],
           master_key: ENV['PARSE_MASTER_KEY'],
           quiet: true

options = {}
OptionParser.new do |opts|
  opts.banner = 'USAGE: ruby parse_upload.rb filenames class_name column_name'
  opts.on('--col col') { |v| options[:column_name] = v }
  opts.on('--class class') { |v| options[:class_name] = v }
end.parse!

if ARGV.empty?
  puts 'Need to specify files to upload'
  exit
else
  options[:filenames] = ARGV
end

options[:filenames].each do |filename|
  file_data = IO.read(filename)
  if file_data.size > 10 * 1024 * 1024
    puts "the file #{filename} is over 10MB and too big for parse to store"
    exit
  end

  file = Parse::File.new(
    body: file_data,
    local_filename: URI.escape(filename),
    content_type: MIME::Type.of(filename).first.preferred_extension
  )
  file.save

  Parse::Object.new(options[:class_name]).tap do |obj|
    obj[options[:column_name]] = file
    if File.file?('config.yml')
      pairs = YAML.load_file('config.yml')
      paris.keys.each do |key|
        obj[key] = pairs[key]
      end
    end
  end.save
end

puts 'Success!'
