# 当たり判定の公式をまとめたファイル
require 'mittsu'

#! 当たり判定のブロックとラケットとの適切な距離を求める公式
def raketto_to_box(w, l)  #w:ラケットの厚さ, l:ラケットの長さ
  return (1.0/(2.0*w))*(w*w+1.0/4.0*l*l)+w/2.0
end
