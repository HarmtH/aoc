#!/usr/bin/ruby

data = ARGF.each_char.reject{|c| c== "\n"}

blocks = []
data.each_with_index {|size, idx|
  size.to_i.times {
    blocks << (idx.even? ? idx / 2 : '.')
  }
}

(data.size / 2).downto(0) {|id|
  src = (blocks.index(id)..blocks.rindex(id))

  search_pos = 0
  loop {
    search_pos += blocks[search_pos..].index('.') || break
    dst_size = blocks[search_pos..].take_while{|v| v == '.'}.size
    if search_pos < src.min && dst_size >= src.size
      dst_replace = (search_pos...(search_pos + src.size))
      blocks[dst_replace], blocks[src] = blocks[src], blocks[dst_replace]
      break
    end
    search_pos += dst_size
  }
}

puts blocks.each_with_index.filter_map{|id, idx| id * idx if id != '.'}.sum
