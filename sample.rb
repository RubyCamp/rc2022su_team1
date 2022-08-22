# ライブラリの読み込み
require 'mittsu'

# ウィンドウの大きさの定義
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600

# アスペクト比の定義
ASPECT = SCREEN_WIDTH.to_f / SCREEN_HEIGHT.to_f

# ウィンドウのレンダリングの定義
renderer = Mittsu::OpenGLRenderer.new width: SCREEN_WIDTH, height: SCREEN_HEIGHT, title: 'game title'

# シーンの導入
scene = Mittsu::Scene.new

# カメラの定義
camera = Mittsu::PerspectiveCamera.new(75.0, ASPECT, 0.1, 1000.0)
camera.position.z = 5.0


# オブジェクト(四角い緑色の物体)の定義
box = Mittsu::Mesh.new(
  Mittsu::BoxGeometry.new(1.0, 1.0, 1.0),
  Mittsu::MeshBasicMaterial.new(color: 0x00ff00)
)

# シーンにボックスを追加する処理
scene.add(box)

# レンダリングをしてくださいと命令する処理かな？
renderer.window.run do
  # シーンに追加した緑色のボックスを回転させる処理
  box.rotation.x += 0.1
  box.rotation.y += 0.1

  # シーンとカメラの追加を行う処理
  renderer.render(scene, camera)
end