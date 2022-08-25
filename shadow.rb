require 'mittsu'

scene = Mittsu::Scene.new
scene.fog = Mittsu::Uniform.new(:float, 2000.0)
camera = Mittsu::PerspectiveCamera.new(75.0, 1.333, 0.1, 1000.0)
renderer = Mittsu::OpenGLRenderer.new width: 800, height: 600, title: 'RubyCamp 2022'

# レンダラーのシャドウマップを有効にし、ソフトシャドウに設定しておく
renderer.shadow_map_enabled = true
renderer.shadow_map_type = Mittsu::PCFSoftShadowMap

light = Mittsu::SpotLight.new(0xffffff, 1.0)
light.position.set(1, 2, 1)

# ライトが影を生成するようにする
light.cast_shadow = true

# ライトが生成する影のパラメータを設定する
light.shadow_darkness = 0.5     # 影の暗さを設定（あまり暗すぎても不自然なので半分程度に）
light.shadow_map_width = 1024   # シャドウマップのサイズ（横幅）を定義
light.shadow_map_height = 1024  # シャドウマップのサイズ（縦幅）を定義
light.shadow_camera_near = 1.0  # 影とカメラのクリッピング距離（近端）を設定
light.shadow_camera_far = 100.0 # 影とカメラのクリッピング距離（遠端）を設定
light.shadow_camera_fov = 75.0  # 影の撮影画角を設定（基本的にはカメラのFOVに合わせておくのが吉）
scene.add(light)

geom_box = Mittsu::BoxGeometry.new(0.5, 0.5, 0.5, 4, 4, 4)
mat_box = Mittsu::MeshPhongMaterial.new(color: 0x00ff00)
mesh_box = Mittsu::Mesh.new(geom_box, mat_box)
mesh_box.position.z = -1.5

# ライトからの光を受けた立方体メッシュが影を生成するように設定
mesh_box.cast_shadow = true

scene.add(mesh_box)

geom_plane = Mittsu::PlaneGeometry.new(3, 3)
mat_plane = Mittsu::MeshPhongMaterial.new(color: 0x00ff00)
mesh_plane = Mittsu::Mesh.new(geom_plane, mat_plane)
mesh_plane.position.z = -3
mesh_plane.position.y = -1
mesh_plane.rotation.x = -Math::PI / 2

# 平面メッシュが影を受け取るように設定
mesh_plane.receive_shadow = true

scene.add(mesh_plane)


renderer.window.run do
  mesh_box.rotation.x += 0.05
  mesh_box.rotation.y += 0.05
  renderer.render(scene, camera)
end
