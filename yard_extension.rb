# -*- mode: ruby; coding: utf-8 -*-
require 'yard'

# yardoc -e yard_extension.rb ext/opencv/*.cpp

module YARD
  module Parser
    module Cpp
      class CppParser < YARD::Parser::C::CParser

        def initialize(source, file = '(stdin)')
          source = source.lines.map { |line|
            line = line =~ /\A\s*(?:namespace|extern)\s*/ ? "\n" : line
            line.gsub!(/RUBY_METHOD_FUNC\s*\((?:[0-9a-zA-Z_:]+::)([0-9a-zA-Z_]+)\)/) { "RUBY_METHOD_FUNC(#{$1})" }
            line
          }.join
          super(source, file)
        end
      end
    end
  end
end

YARD::Parser::SourceParser.register_parser_type(:c, YARD::Parser::C::CParser, ['c', 'cc']) # Remove .cpp
YARD::Parser::SourceParser.register_parser_type(:cpp, YARD::Parser::Cpp::CppParser, ['cpp'])
# YARD::Handlers::Processor.register_handler_namespace(:cpp, YARD::Handlers::Cpp)
YARD::Handlers::Processor.register_handler_namespace(:cpp, YARD::Handlers::C)
YARD::Parser::SourceParser.parser_type = :cpp
YARD::Tags::Library.define_tag('OpenCV Function', :opencv_func, :with_types_and_name)
