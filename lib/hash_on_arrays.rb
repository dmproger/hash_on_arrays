# frozen_string_literal: true

class HashOnArrays
  def initialize
    @slots = []
  end

  def set(key, value)
    slot = @slots[hashf(key)] ||= [[], []] # [[keys], [values]]
    slot[1][slot[0].index(key)] = value
  rescue TypeError
    slot[0] << key
    slot[1] << value
  end

  def get(key)
    slot = @slots[hashf(key)] || return
    slot[1][slot[0].index(key) || return]
  end

  private

  def hashf(key)
    key.bytes.size # for example
  end
end

#
# in get method, before line 18 we can add:
# return slot[1][0] if slot[0].size == 1
#
# it's force return in no collision case,
# where not nessesary search for key index, it's 0
#
