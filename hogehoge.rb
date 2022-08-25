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
#? おまじない。なぜこれがいるのか分からないので...
scene.fog = Mittsu::Uniform.new(:float, 2000.0)

# レンダラーのシャドウマップを有効にし、ソフトシャドウに設定しておく
renderer.shadow_map_enabled = true
renderer.shadow_map_type = Mittsu::PCFSoftShadowMap

# light = Mittsu::DirectionalLight.new(0xffffff, 1.0)
light = Mittsu::DirectionalLight.new(0xffffff, 10.0)
light.position.set(1, 2, 1)

# ライトが影を生成するようにする
light.cast_shadow = true

# ライトが生成する影のパラメータを設定する
# light.shadow_darkness = 0.5     # 影の暗さを設定（あまり暗すぎても不自然なので半分程度に）
# light.shadow_map_width = 1024   # シャドウマップのサイズ（横幅）を定義
# light.shadow_map_height = 1024  # シャドウマップのサイズ（縦幅）を定義
# light.shadow_camera_near = 1.0  # 影とカメラのクリッピング距離（近端）を設定
# light.shadow_camera_far = 100.0 # 影とカメラのクリッピング距離（遠端）を設定
# light.shadow_camera_fov = 75.0  # 影の撮影画角を設定（基本的にはカメラのFOVに合わせておくのが吉）
scene.add(light)

# カメラの定義
camera = Mittsu::PerspectiveCamera.new(75.0, ASPECT, 0.1, 1000.0)
camera.position.y = - 35.0
# camera.position.y = - 35.0 - 20
camera.position.z = 50.0
# camera.position.z = 50.0 - 48
# camera.position.x = 40

# オブジェクト(球体)の定義
sphere_radius = 1.0
sphere = Mittsu::Mesh.new(
  Mittsu::SphereGeometry.new(sphere_radius, 16, 16),
  Mittsu::MeshPhongMaterial.new(color: 0x00ff00)
)
# ライトからの光を受けたボールが影を生成するように設定
sphere.cast_shadow = true

#ラケットA
raketto_a_width = 1
raketto_a_height = 10
raketto_a_depth = 10
raketto_a = Mittsu::Mesh.new(
  Mittsu::BoxGeometry.new(raketto_a_width, raketto_a_height, raketto_a_depth),
  Mittsu::MeshPhongMaterial.new(color: 0X0000FF, wireframe:false)
)

#ラケットB
raketto_b_width = 1
raketto_b_height = 10
raketto_b_depth = 10
raketto_b = Mittsu::Mesh.new(
  Mittsu::BoxGeometry.new(raketto_b_width, raketto_b_height, raketto_b_depth),
  Mittsu::MeshPhongMaterial.new(color: 0XFF0000, wireframe:false)
)

# 当たり判定のブロックとラケットとの適切な距離を求める公式
w = (raketto_a_width).to_f
l = (raketto_a_height).to_f
# box_distance = (1.0/(2.0*w))*(w*w+1.0/4.0*l*l) + raketto_a_width/2.0 # 当たり判定のブロックとラケットの距離 # 1/4は0になる...これで１時間取られたってマ？
box_distance = (1.0/(2.0*w))*(w*w+1.0/4.0*l*l)+raketto_a_width/2.0 # 当たり判定のブロックとラケットの距離 # 1/4は0になる...これで１時間取られたってマ？

# ラケットAの当たり判定で使うブロック
box_a = Mittsu::Mesh.new(
  Mittsu::SphereGeometry.new(1, 16, 16),
  Mittsu::MeshPhongMaterial.new(color: 0XFF0000, wireframe:false)
)

# ラケットBの当たり判定で使うブロック
box_b = Mittsu::Mesh.new(
  Mittsu::SphereGeometry.new(1, 16, 16),
  Mittsu::MeshPhongMaterial.new(color: 0X0000FF, wireframe:false)
)

# 卓球台の当たり判定のブロック
table_box = Mittsu::Mesh.new(
  Mittsu::SphereGeometry.new(1, 16, 16),
  Mittsu::MeshPhongMaterial.new(color: 0X00FF00, wireframe:false)
)
table_box.position.x = 0
table_box.position.y = 0
table_box.position.z = -1000 #!遠くに配置することで当たり判定が卓球台面上すべてにあるように見せかける
table_distance = (table_box.position.z - 2).abs #判定に使う変数


#卓球台
table = create_table
# 卓球台が影を受け取るように設定
table.receive_shadow = true
#卓球台の左足
tableLeg_left = create_tableLeftLegs
#卓球台の右足
tableLeg_right = create_tableRightLegs

# シーンにオブジェクトを追加する処理
scene.add(sphere, raketto_a, raketto_b, box_a, box_b, table, tableLeg_left, tableLeg_right, table_box)

# 位置調整
raketto_x = 40  #ラケットのx座標の絶対値
box_a.position.x = -1 * (box_distance + raketto_x)  #box_distanceはラケットとブロックの距離なので原点からラケットまでの距離を加算する
box_b.position.x = 1 * (box_distance + raketto_x)

#ボールの移動方向とスピード
dx = 1
dy = 0
dz = -0.1
flag = 0  # ボールを動かすかのフラグ

# レンダリングをしてくださいと命令する処理かな？
renderer.window.run do
  random_Number = rand(0..0.1)
  # ボールがラケットより後ろに行った後原点に戻り一時停止する。spaceを押したら再度ボールが動く
  if renderer.window.key_down?(GLFW_KEY_SPACE)
    flag = 0
  end

  # シーンに追加した球体をランダムに移動させる処理
  if flag == 0
    sphere.position.x += dx
    sphere.position.y += dy
    sphere.position.z += dz
  end
  
  #ラケットA
  raketto_a.position.x = -1 * raketto_x
  if renderer.window.key_down?(GLFW_KEY_D)
    box_a.position.y += 1
    raketto_a.position.y += 1
  end
  if renderer.window.key_down?(GLFW_KEY_A)
    box_a.position.y -= 1
    raketto_a.position.y -= 1
  end
  if renderer.window.key_down?(GLFW_KEY_W)
    box_a.position.z += 1
    raketto_a.position.z += 1
  end
  if renderer.window.key_down?(GLFW_KEY_S)
    box_a.position.z -= 1
    raketto_a.position.z -= 1
  end

  #ボールとラケットA側の当たり判定ボックスとの距離
  distance = sphere.position.distance_to(box_a.position)
  #当たり判定
  if distance <= box_distance + sphere_radius
    dx = 1
    dy = random_Number
    dz *= -1
  end

  #ラケットB
  raketto_b.position.x = 1 * raketto_x
  if renderer.window.key_down?(GLFW_KEY_UP)
    box_b.position.z += 1
    raketto_b.position.z += 1
  end
  if renderer.window.key_down?(GLFW_KEY_DOWN)
    box_b.position.z -= 1
    raketto_b.position.z -= 1
  end
  if renderer.window.key_down?(GLFW_KEY_LEFT)
    box_b.position.y += 1
    raketto_b.position.y += 1
  end
  if renderer.window.key_down?(GLFW_KEY_RIGHT)
    box_b.position.y -= 1
    raketto_b.position.y -= 1
  end

  #ボールとラケットB側の当たり判定ボックスとの距離
  distance = sphere.position.distance_to(box_b.position)
  #当たり判定
  if distance <= box_distance + sphere_radius
    dx = -1
    dy = -1 * random_Number
    dz *= -1
  end

  #ボールと卓球台の距離を求める
  distance_table_to_boll = sphere.position.distance_to(table_box.position)
  #当たり判定
  if distance_table_to_boll <= table_distance
    dz = 0.1
  end

  # ボールがラケットより後ろに行った時の処理
  # * ラケットより後ろに行く→原点に移動。この時移動を止める。spaceキーで再度動かすように実装
  if sphere.position.x < -40 or sphere.position.x > 40
    scene.remove(sphere)
    sphere.position.x = 0
    sphere.position.y = 0
    sphere.position.z = 0
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
