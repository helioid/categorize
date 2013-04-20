# encoding: utf-8

# Loads mkmf which is used to make makefiles for Ruby extensions
require 'mkmf'

# Do the work
create_makefile('categorize/categorize')
