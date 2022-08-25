# 様々な物体を生成する関数をまとめたファイル
require 'mittsu'

# ボール
def create_sphere(sphere_radius)
  Mittsu::Mesh.new(
  Mittsu::SphereGeometry.new(sphere_radius, 16, 16),
  Mittsu::MeshPhongMaterial.new(color: 0x00ff00)
)
end

# ラケットA
def create_raketto_a(raketto_a_width, raketto_a_height, raketto_a_depth)
  Mittsu::Mesh.new(
  Mittsu::BoxGeometry.new(raketto_a_width, raketto_a_height, raketto_a_depth),
  Mittsu::MeshPhongMaterial.new(color: 0X0000FF, wireframe:false)
)
end

# ラケットB
def create_raketto_b(raketto_b_width, raketto_b_height, raketto_b_depth)
  Mittsu::Mesh.new(
  Mittsu::BoxGeometry.new(raketto_b_width, raketto_b_height, raketto_b_depth),
  Mittsu::MeshPhongMaterial.new(color: 0XFF0000, wireframe:false)
)
end

# ラケットA側の当たり判定のboxを生成する関数
def create_box_a
  Mittsu::Mesh.new(
  Mittsu::SphereGeometry.new(1, 16, 16),
  Mittsu::MeshPhongMaterial.new(color: 0XFF0000, wireframe:false)
)
end

# ラケットB側の当たり判定のboxを生成する関数
def create_box_b
  Mittsu::Mesh.new(
  Mittsu::SphereGeometry.new(1, 16, 16),
  Mittsu::MeshPhongMaterial.new(color: 0X0000FF, wireframe:false)
)
end

# 卓球台の当たり判定のブロック
def create_table_box
  Mittsu::Mesh.new(
  Mittsu::SphereGeometry.new(1, 16, 16),
  Mittsu::MeshPhongMaterial.new(color: 0X00FF00, wireframe:false)
)
end

#テーブルの台
def create_table
  Mittsu::Mesh.new(
  Mittsu::PlaneGeometry.new(67, 40, 40),
  Mittsu::MeshPhongMaterial.new(color: 0X3F85CD)
  )
end

#テーブルの脚(左)
def create_tableLeftLegs
  mesh = Mittsu::Mesh.new(
  Mittsu::BoxGeometry.new(5, 5, 40),
  Mittsu::MeshPhongMaterial.new(color: 0XA9A9A9)
  )
  mesh.position.set(-43.5,-11.8,-40)
  return mesh
end

#テーブルの脚(右)
def create_tableRightLegs
  mesh = Mittsu::Mesh.new(
  Mittsu::BoxGeometry.new(5, 5, 40),
  Mittsu::MeshPhongMaterial.new(color: 0XA9A9A9)
  )
  mesh.position.set(43.5,-11.8,-40)
  return mesh
end
