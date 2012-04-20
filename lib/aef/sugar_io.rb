# encoding: UTF-8
=begin
Copyright Alexander E. Fischer <aef@raxys.net>, 2012

This file is part of SugarIO.

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
=end

require 'set'

# Namespace for projects of Alexander E. Fischer <aef@raxys.net>.
#
# If you want to be able to simply type Example instead of Aef::Example to
# address classes in this namespace simply write the following before using the
# classes.
#
# @example Including the namespace
#   include Aef
# @author Alexander E. Fischer
module Aef

  # Namespace for the sugar_io library
  module SugarIO

    # List of all valid mode Symbols
    #
    # @private
    MODE_SYMBOLS = [:read, :overwrite, :append, :binary, :text].freeze
  
    # Converts a set of mode Symbols to a classic mode String.
    #
    # @param [Set, Array] modes a combination of the mode symbols :read,
    #   :overwrite, :append, :binary and :text
    # @return [String] a classic mode String
    def self.parse_mode_symbols(*modes)
      modes = modes.flatten.to_set
      mode_string = ''
  
      if Set[:binary, :text].subset?(modes)
        raise ArgumentError, ':binary and :text are mutually exclusive'
      else
        mode_string << 'b' if modes.include?(:binary)
        mode_string << 't' if modes.include?(:text)
      end
  
      if modes.include?(:overwrite) || modes.include?(:append)
        
        if Set[:overwrite, :append].subset?(modes)
          raise ArgumentError, ':truncate and :append are mutually exclusive'
        end
        
        if modes.include?(:read)
          if modes.include?(:append)
            mode_string << 'a+' 
          else
            mode_string << 'w+'
          end
        else
          if modes.include?(:append)
            mode_string << 'a'
          else
            mode_string << 'w'
          end
        end
      else
        mode_string << 'r'
      end
    end

    # Generates an options Hash out of a given argument list.
    #
    # @param [Array] list of arguments
    # @return [Hash] the arguments as options Hash
    def self.generate_options(arguments)
      if arguments.last.is_a?(Hash)
        options = arguments.pop
      else
        options = {}
      end

      options.delete(:binmode)
      options.delete(:textmode)
      options[:mode] = Aef::SugarIO.parse_mode_symbols(arguments)
      options
    end

    # Sugar-enhanced open module method.
    #
    # @param [:read, :overwrite, :append, :text, :binary] mode_symbols a list of mode Symbols
    # @param [Hash] options
    # @option options [Encoding, String] external_encoding the encoding the external file is expected to be in
    # @option options [Encoding, String] internal_encoding the encoding read data will be converted to
    # @option options [Encoding, String] encoding sets internal and external encoding simultaniously
    # @option options [true, false] autoclose if the value is false, the
    #   file descriptor will be kept open after the IO instance gets finalized
    # @return [IO] an IO object
    def self.open(file, *arguments, &block)
      IO.open(file, generate_options(arguments), &block)
    end

    # Sugar-enhanced open instance method.
    #
    # @overload sugar_open(*mode_symbols, options = {})
    # @overload sugar_open(*mode_symbols, options = {}, &block)
    # @param [:read, :overwrite, :append, :text, :binary] mode_symbols a list of mode Symbols
    # @param [Hash] options
    # @option options [Encoding, String] external_encoding the encoding the external file is expected to be in
    # @option options [Encoding, String] internal_encoding the encoding read data will be converted to
    # @option options [Encoding, String] encoding sets internal and external encoding simultaniously
    # @option options [true, false] autoclose if the value is false, the
    #   file descriptor will be kept open after the IO instance gets finalized
    # @return [IO] an IO object
    def sugar_open(*arguments, &block)
      open(generate_options(arguments), &block)
    end
  end
end
