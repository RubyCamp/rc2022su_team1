# ライブラリの読み込み
require 'mittsu'


#ラケット加速アイテム=A(ピンク球)
def create_item
  acceleration_item = Mittsu::Mesh.new(
  Mittsu::SphereGeometry.new(2 , 16, 16),
  Mittsu::MeshBasicMaterial.new(color: 0XB469FF)
  )

  #アイテムの生成場所
  item_position_x = rand(-20..20)
  item_position_y = rand(-10..10)
  item_position_z = 0

  acceleration_item.position.set(item_position_x,item_position_y,item_position_z)
  return acceleration_item
end