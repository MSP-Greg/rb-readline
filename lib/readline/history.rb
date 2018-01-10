# encoding: US-ASCII
#
# readline.rb -- GNU Readline module
# Copyright (C) 1997-2001  Shugo Maeda
#
# Ruby translation by Park Heesob phasis@gmail.com


module Readline

  # The History class encapsulates a history of all commands entered by
  # users at the prompt, providing an interface for inspection and retrieval
  # of all commands.
  class History
    extend Enumerable

    class << self
    
    # The History class, stringified in all caps.
    #--
    # Why?
    #
    def to_s
      "HISTORY"
    end

    # Returns the command that was entered at the specified +index+
    # in the history buffer.
    #
    # Raises an IndexError if the entry is nil.
    #
    def [](index)
      index += RbReadline.history_length if index < 0
      entry = RbReadline.history_get(RbReadline.history_base+index)
      raise(IndexError,"invalid index") if entry.nil?
      entry.line.dup
    end

    # Sets the command +str+ at the given index in the history buffer.
    #
    # You can only replace an existing entry. Attempting to create a new
    # entry will result in an IndexError.
    #
    def []=(index,str)
      index += RbReadline.history_length if index < 0
      entry = RbReadline.replace_history_entry(index,str,nil)
      raise(IndexError,"invalid index") if entry.nil?
      str
    end

    # Synonym for Readline.add_history.
    #
    def <<(str)
      RbReadline.add_history(str)
    end

    # Pushes a list of +args+ onto the history buffer.
    #
    def push(*args)
      args.each {|str| RbReadline.add_history(str) }
    end

    # Removes and returns the last element from the history buffer.
    #
    def pop
      RbReadline.history_length > 0 ?
        rb_remove_history(RbReadline.history_length-1) : nil
    end

    # Removes and returns the first element from the history buffer.
    #
    def shift
      RbReadline.history_length > 0 ? rb_remove_history(0) : nil
    end

    # Iterates over each entry in the history buffer.
    #
    def each
      for i in 0 ... RbReadline.history_length
        entry = RbReadline.history_get(RbReadline.history_base + i)
        break if entry.nil?
        yield entry.line.dup
      end
      self
    end

    # Returns the length of the history buffer.
    #
    def length
      RbReadline.history_length
    end

    # Synonym for Readline.length.
    #
    def size
      RbReadline.history_length
    end

    # Returns a bolean value indicating whether or not the history buffer
    # is empty.
    #
    def empty?
      RbReadline.history_length == 0
    end

    # Deletes an entry from the history buffer at the specified +index+.
    #
    def delete_at(index)
      if 0 <= index || index < RbReadline.history_length
        rb_remove_history(index)
      else
        raise(IndexError, "invalid index")        
      end
    end

    def clear
      if RbReadline.history_length > 0
        upper = RbReadline.history_length - 1
        upper.downto(0) {|i| RbReadline.remove_history(i) }
      end
    end

    private

    # Internal function that removes the item at +index+ from the history
    # buffer, performing necessary duplication in the process.
    #
    def rb_remove_history(index)
      entry = RbReadline.remove_history(index)
      if (entry)
        val = entry.line.dup
        entry = nil
        val
      else
        nil
      end
    end

    end # class << self
  end
end
