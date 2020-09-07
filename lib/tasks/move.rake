require 'fileutils'  

namespace :move do
  desc 'Move the files from docs to root'
  task :init do
    puts 'Moving docs folder'
    FileUtils.cp_r 'docs/.', '.'
    FileUtils.rm_rf 'docs'
  end
end
