#!/usr/bin/ruby

data = ARGF.each_char.reject{|c| c== "\n"}

blocks = []
data.each_with_index {|size, idx|
  size.to_i.times {
    blocks << (idx.even? ? idx / 2 : '.')
  }
}

dst_idx = 0
src_idx = blocks.size - 1
loop {
  dst_idx += blocks[dst_idx..].index('.')
  src_idx = blocks[..src_idx].rindex{|v| v != '.'}
  break if dst_idx >= src_idx

  blocks[dst_idx], blocks[src_idx] = blocks[src_idx], blocks[dst_idx]
}

puts blocks[0..src_idx].each_with_index.map{|id, idx| id * idx}.sum
