require 'mittsu'

# テクスチャを貼り付けるmeshの長さ
@mesh_length = 200

#地面
def create_ground_image
  geometry = Mittsu::PlaneGeometry.new(@mesh_length, @mesh_length, 20)
  texture = Mittsu::ImageUtils.load_texture(File.join File.dirname(__FILE__), 'textures/ground.png')
  material = Mittsu::MeshBasicMaterial.new(map: texture)
  ground_img = Mittsu::Mesh.new(geometry, material)
  ground_img.position.set(0,0,-50)
  return ground_img
end

#空
def create_sky_image
  geometry = Mittsu::BoxGeometry.new(@mesh_length, 1, @mesh_length)
  texture = Mittsu::ImageUtils.load_texture(File.join File.dirname(__FILE__), 'textures/sky.png')
  material = Mittsu::MeshBasicMaterial.new(map: texture)
  sky_img = Mittsu::Mesh.new(geometry, material)
  sky_img.position.set(0,80,0)
  return sky_img
end

#左壁
def create_left_image
  geometry = Mittsu::BoxGeometry.new(1, @mesh_length, @mesh_length)
  texture = Mittsu::ImageUtils.load_texture(File.join File.dirname(__FILE__), 'textures/left.png')
  material = Mittsu::MeshBasicMaterial.new(map: texture)
  left_img = Mittsu::Mesh.new(geometry, material)
  left_img.position.set(-80,0,0)
  return left_img
end

#右壁
def create_right_image
  geometry = Mittsu::BoxGeometry.new(1, @mesh_length, @mesh_length)
  texture = Mittsu::ImageUtils.load_texture(File.join File.dirname(__FILE__), 'textures/right.png')
  material = Mittsu::MeshBasicMaterial.new(map: texture)
  right_img = Mittsu::Mesh.new(geometry, material)
  right_img.position.set(80,0,0)
  return right_img
end


