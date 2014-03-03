require 'rake'
require 'fileutils'


# Get a reference to the current working directory
cwd = File.dirname(__FILE__)


desc 'Create a new post'
task :post do
  post_title = ENV['post']
  format = ENV['format'] || 'md'
  dir = ENV['post_dir'] || '_posts'
  dir = "#{cwd}/#{dir}"

  unless post_title
    puts 'Please specify a title.'
    next
  end

  post_title = post_title.downcase.gsub(/ /, '-')

  FileUtils.touch(Time.now.strftime("#{dir}/%Y-%m-%d-#{post_title}.#{format}"))
end


task :default => :post
