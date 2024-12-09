#!/usr/bin/ruby

blocks = []
ARGF.each_char.each_with_index{|size, idx|
  id = idx.even? ? idx / 2 : '.'
  size.to_i.times {
    blocks << id
  }
}

dest_idx = 0
src_idx = blocks.size - 1

loop {
  dest_idx += blocks[dest_idx..].index('.')
  src_idx = blocks[..src_idx].rindex{|v| v.is_a?(Integer)}
  break if dest_idx >= src_idx

  blocks[dest_idx], blocks[src_idx] = blocks[src_idx], blocks[dest_idx]
}

puts blocks[0..src_idx].each_with_index.map{|id, idx| id * idx}.sum
