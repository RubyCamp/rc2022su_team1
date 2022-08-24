# ライブラリの読み込み
require 'mittsu'

#他ファイルの読み込み
require_relative 'table'

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
camera.position.y = - 35.0
camera.position.z = 50.0


# オブジェクト(球体)の定義
sphere = Mittsu::Mesh.new(
  Mittsu::SphereGeometry.new(1, 16, 16),
  Mittsu::MeshBasicMaterial.new(color: 0x00ff00)
)

#ラケットA
raketto_a = Mittsu::Mesh.new(
  Mittsu::BoxGeometry.new(1, 10, 10),
  Mittsu::MeshBasicMaterial.new(color: 0X0000FF)
)

#ラケットB
raketto_b = Mittsu::Mesh.new(
  Mittsu::BoxGeometry.new(1, 10, 10),
  Mittsu::MeshBasicMaterial.new(color: 0XFF0000)
)

#卓球台
table = create_table
#卓球台の左足
tableLeg_left = create_tableLeftLegs
#卓球台の右足
tableLeg_right = create_tableRightLegs

# シーンにオブジェクトを追加する処理
scene.add(sphere,raketto_a,raketto_b,table,tableLeg_left,tableLeg_right)

dx = 1
flag = 0  # ボールを動かすかのフラグ

# レンダリングをしてくださいと命令する処理かな？
renderer.window.run do
  # ボールがラケットより後ろに行った後原点に戻り一時停止する。spaceを押したら再度ボールが動く
  if renderer.window.key_down?(GLFW_KEY_SPACE)
    flag = 0
  end

  # シーンに追加した球体をランダムに移動させる処理
  if flag == 0
    sphere.position.x += dx
  end
  
  #ラケットA
  raketto_a.position.x = -40
  if renderer.window.key_down?(GLFW_KEY_S)
    raketto_a.position.y -= 1
  end
  if renderer.window.key_down?(GLFW_KEY_W)
    raketto_a.position.y += 1
  end

  #距離
  distance = sphere.position.distance_to(raketto_a.position)
  if distance <= 1.5
    dx = 1
  end

  #ラケットB
  raketto_b.position.x = 40
  if renderer.window.key_down?(GLFW_KEY_DOWN)
    raketto_b.position.y -= 1
  end
  if renderer.window.key_down?(GLFW_KEY_UP)
    raketto_b.position.y += 1
  end

  #距離
  distance = sphere.position.distance_to(raketto_b.position)
  if distance <= 1.5
    dx = -1
  end

  # ボールがラケットより後ろに行った時の処理
  #* ラケットより後ろに行く→原点に移動。この時移動を止める。spaceキーで再度動かすように実装
  if sphere.position.x < -40 or sphere.position.x > 40
    scene.remove(sphere)
    sphere.position.x = 0
    scene.add(sphere)
    flag = 1
  end

  #卓球台の位置調整
  table.position.x = 0

  #カメラが座標(0,0,0)を見続ける
  camera.look_at(Mittsu::Vector3.new(0, 0, 0))

  # シーンとカメラの追加を行う処理
  renderer.render(scene, camera)
end
