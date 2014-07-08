# Created by GitVers - Fill the commented stuff out yourself

require 'rubygems'
require 'rubygems/package_task'

spec = Gem::Specification.new do |gem|
    gem.name         = File.basename(`git rev-parse --show-toplevel`).chop
    gem.version      = `gitver version`
    
    gem.author       = `git config --get user.name`
    gem.email        = `git config --get user.email`
    gem.homepage     = "https://github.com/floomby/gitver"
    gem.summary      = "Creates metadata for primord rf data"
    gem.description  = "Process the logs from gnuradio and generates metadata"
    
    gem.files        = `git ls-files | grep -E '(^tmp)|(^scripts)' -v`.split($\)
    
    gem.executables  = ["primord-metadata"]
end

Gem::PackageTask.new(spec) do |pkg|
    pkg.gem_spec = spec
end
