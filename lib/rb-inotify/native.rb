require 'ffi'

module INotify
  # This module contains the low-level foreign-function interface code
  # for dealing with the inotify C APIs.
  # It's an implementation detail, and not meant for users to deal with.
  #
  # @private
  module Native
    extend FFI::Library
    ffi_lib FFI::Library::LIBC

    # The C struct describing an inotify event.
    #
    # @private
    class Event < FFI::Struct
      layout(
        :wd, :int,
        :mask, :uint32,
        :cookie, :uint32,
        :len, :uint32)
    end

    # The C struct describing a poll fd
    #
    # @private
    class PollFD < FFI::Struct
      layout(
        :fd,      :int,
        :events,  :short,
        :revents, :short)
    end

    attach_function :inotify_init, [], :int
    attach_function :inotify_add_watch, [:int, :string, :uint32], :int
    attach_function :inotify_rm_watch, [:int, :uint32], :int

    find_type(:nfds_t) rescue typedef(:uint32, :nfds_t)
    attach_function :poll, [:pointer, :nfds_t, :int], :int
    attach_function :read, [:int, :pointer, :size_t], :ssize_t
    attach_function :close, [:int], :int
  end
end
