#!/usr/bin/ruby

blocks = []
id = 0
ARGF.each_char.each_with_index{|size, idx|
  next if size == "\n"
  id = idx.even? ? idx / 2 : '.'
  size.to_i.times {
    blocks << id
  }
}

while id >= 0
  src = (blocks.index(id)..blocks.rindex(id))

  dst = (0..)
  loop {
    next_empty = blocks[dst].index('.')
    break if !next_empty
    dst = ((dst.min + next_empty)..)
    break if dst.min >= src.min
    dst_size = blocks[dst].index{|v| v != '.'} || blocks[dst].size
    if dst_size >= src.size
      dst_replace = (dst.min...(dst.min + src.size))
      blocks[dst_replace], blocks[src] = blocks[src], blocks[dst_replace]
      break
    end
    dst = ((dst.min + dst_size)..)
  }

  id -= 1
end

puts blocks.each_with_index.filter_map{|id, idx| id * idx if id != '.'}.sum
