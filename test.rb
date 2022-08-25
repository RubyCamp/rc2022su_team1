require 'mittsu'

scene = Mittsu::Scene.new
scene.fog = Mittsu::Uniform.new(:float, 2000.0)
camera = Mittsu::PerspectiveCamera.new(75.0, 1.333, 0.1, 1000.0)
renderer = Mittsu::OpenGLRenderer.new width: 800, height: 600, title: 'RubyCamp 2022'

light = Mittsu::DirectionalLight.new(0xffffff)
light.position.set(1, 20, 1)
scene.add(light)

geom_box = Mittsu::BoxGeometry.new(0.5, 0.5, 0.5, 4, 4, 4)
mat_box = Mittsu::MeshPhongMaterial.new(color: 0x00ff00)
mesh_box = Mittsu::Mesh.new(geom_box, mat_box)
mesh_box.position.z = -1.5
scene.add(mesh_box)

geom_plane = Mittsu::PlaneGeometry.new(3, 3)
mat_plane = Mittsu::MeshPhongMaterial.new(color: 0x00ff00)
mesh_plane = Mittsu::Mesh.new(geom_plane, mat_plane)
mesh_plane.position.z = -3
mesh_plane.position.y = -1
mesh_plane.rotation.x = -Math::PI / 2
scene.add(mesh_plane)


renderer.window.run do
	mesh_box.rotation.x += 0.05
	mesh_box.rotation.y += 0.05
	renderer.render(scene, camera)
end