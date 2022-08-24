# ライブラリの読み込み
require 'mittsu'

#テーブルの台
def create_table
  Mittsu::Mesh.new(
  Mittsu::PlaneGeometry.new(67, 40, 40),
  Mittsu::MeshBasicMaterial.new(color: 0X3F85CD)
  )
end

#テーブルの脚(左)
def create_tableLeftLegs
  mesh = Mittsu::Mesh.new(
  Mittsu::BoxGeometry.new(5, 5, 40),
  Mittsu::MeshBasicMaterial.new(color: 0XA9A9A9)
  )
  mesh.position.set(-43.5,-11.8,-40)
  return mesh
end

#テーブルの脚(右)
def create_tableRightLegs
  mesh = Mittsu::Mesh.new(
  Mittsu::BoxGeometry.new(5, 5, 40),
  Mittsu::MeshBasicMaterial.new(color: 0XA9A9A9)
  )
  mesh.position.set(43.5,-11.8,-40)
  return mesh
end