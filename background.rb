require 'mittsu'

#地面
def create_ground_image
  ground_img = Mittsu::Mesh.new(
  Mittsu::PlaneGeometry.new(400, 200, 100),
  Mittsu::MeshBasicMaterial.new(color: 0XE6F0FA)
  )
  ground_img.position.set(0,0,-50)
  return ground_img
end

#空
def create_sky_image
  sky_img = Mittsu::Mesh.new(
  Mittsu::BoxGeometry.new(200, 30, 20),
  Mittsu::MeshBasicMaterial.new(color: 0XEEEEAF)
  )
  sky_img.position.set(10,48,9)
  return sky_img
end

#左壁
def create_left_image
  left_img = Mittsu::Mesh.new(
  Mittsu::BoxGeometry.new(10, 200, 10),
  Mittsu::MeshBasicMaterial.new(color: 0XEEEEAF)
  )
  left_img.position.set(-60,50,9)
  return left_img
end

#右壁
def create_right_image
  right_img = Mittsu::Mesh.new(
  Mittsu::BoxGeometry.new(10, 200, 10),
  Mittsu::MeshBasicMaterial.new(color: 0XEEEEAF)
  )
  right_img.position.set(60,50,9)
  return right_img
end


