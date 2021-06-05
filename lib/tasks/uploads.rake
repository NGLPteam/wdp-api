# frozen_string_literal: true

namespace :uploads do
  desc "Upload a file to a locally running instance"
  task :local, %i[path] => :environment do |t, args|
    client = TusClient.local

    uri = client.upload args[:path]

    puts "Uploaded to:"
    puts "\t#{uri}"
  end

  desc "Upload a file to a remote instance"
  task :remote, %i[url path] => :environment do |t, args|
    client = TusClient.build args[:url]

    uri = client.upload args[:path]

    puts "Uploaded to:"
    puts "\t#{uri}"
  end
end
