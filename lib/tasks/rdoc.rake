# frozen_string_literal: true

require 'sdoc'
require 'rdoc/task'

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'doc/app'
  rdoc.generator = 'sdoc'
  rdoc.template = 'rails'
  rdoc.main = 'README.md'
  rdoc.rdoc_files.include('README.md', 'app/', 'lib/')
  rdoc.options << '-C'
end
