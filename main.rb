# ライブラリの読み込み
require 'mittsu'

#他ファイルの読み込み
require_relative 'table'
require_relative 'mesh_factory'
require_relative 'score_board'
require_relative 'background'

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
# camera.position.y = - 35.0 - 20
camera.position.z = 50.0
# camera.position.z = 50.0 - 48
# camera.position.x = 40

# オブジェクト(球体)の定義
sphere_radius = 1.0
sphere = Mittsu::Mesh.new(
  Mittsu::SphereGeometry.new(sphere_radius, 16, 16),
  Mittsu::MeshBasicMaterial.new(color: 0x00ff00)
)

#ラケットA
raketto_a_width = 1
raketto_a_height = 10
raketto_a_depth = 10
raketto_a = Mittsu::Mesh.new(
  Mittsu::BoxGeometry.new(raketto_a_width, raketto_a_height, raketto_a_depth),
  Mittsu::MeshBasicMaterial.new(color: 0X0000FF, wireframe:false)
)

#ラケットB
raketto_b_width = 1
raketto_b_height = 10
raketto_b_depth = 10
raketto_b = Mittsu::Mesh.new(
  Mittsu::BoxGeometry.new(raketto_b_width, raketto_b_height, raketto_b_depth),
  Mittsu::MeshBasicMaterial.new(color: 0XFF0000, wireframe:false)
)

# 当たり判定のブロックとラケットとの適切な距離を求める公式
w = (raketto_a_width).to_f
l = (raketto_a_height).to_f
# box_distance = (1.0/(2.0*w))*(w*w+1.0/4.0*l*l) + raketto_a_width/2.0 # 当たり判定のブロックとラケットの距離 # 1/4は0になる...これで１時間取られたってマ？
box_distance = (1.0/(2.0*w))*(w*w+1.0/4.0*l*l)+raketto_a_width/2.0 # 当たり判定のブロックとラケットの距離 # 1/4は0になる...これで１時間取られたってマ？

# ラケットAの当たり判定で使うブロック
box_a = Mittsu::Mesh.new(
  Mittsu::SphereGeometry.new(1, 16, 16),
  Mittsu::MeshBasicMaterial.new(color: 0XFF0000, wireframe:false)
)

# ラケットBの当たり判定で使うブロック
box_b = Mittsu::Mesh.new(
  Mittsu::SphereGeometry.new(1, 16, 16),
  Mittsu::MeshBasicMaterial.new(color: 0X0000FF, wireframe:false)
)

# 卓球台の当たり判定のブロック
table_box = Mittsu::Mesh.new(
  Mittsu::SphereGeometry.new(1, 16, 16),
  Mittsu::MeshBasicMaterial.new(color: 0X00FF00, wireframe:false)
)
table_box.position.x = 0
table_box.position.y = 0
table_box.position.z = -1000 #!遠くに配置することで当たり判定が卓球台面上すべてにあるように見せかける
table_distance = (table_box.position.z - 2).abs #判定に使う変数


#卓球台
table = create_table
#卓球台の左足
tableLeg_left = create_tableLeftLegs
#卓球台の右足
tableLeg_right = create_tableRightLegs

#スコアボード
score_board_left =ScoreBoard.new(x: -20, y: -26, z:30)
score_board_right =ScoreBoard.new(x: 15, y: -26, z:32)
score_left = 0
score_right = 0

#背景
ground_image = create_ground_image
sky_image = create_sky_image
left_wall = create_left_image
right_wall = create_right_image

# シーンにオブジェクトを追加する処理
scene.add(sphere, raketto_a, raketto_b, box_a, box_b, table,
          tableLeg_left, tableLeg_right, table_box,score_board_left.container,
          score_board_right.container,ground_image,sky_image,left_wall,right_wall)

# 位置調整
raketto_x = 40  #ラケットのx座標の絶対値
box_a.position.x = -1 * (box_distance + raketto_x)  #box_distanceはラケットとブロックの距離なので原点からラケットまでの距離を加算する
box_b.position.x = 1 * (box_distance + raketto_x)

#ボールの移動方向とスピード
dx = 1

dy = 0
dz = -0.1
flag = 0  # ボールを動かすかのフラグ

# レンダリングをしてくださいと命令する処理かな？毎フレーム
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
  if sphere.position.x < -40
    scene.remove(sphere)
    sphere.position.x = 0
    sphere.position.y = 0
    sphere.position.z = 0
    scene.add(sphere)
    flag = 1
    score_right += 1
  elsif sphere.position.x > 40
    scene.remove(sphere)
    sphere.position.x = 0
    sphere.position.y = 0
    sphere.position.z = 0
    scene.add(sphere)
    flag = 1
    score_left += 1
  end

  #卓球台の位置調整
  table.position.x = 0

  #スコアボードに得点を表示
  score_board_left.draw_score(score_left)
  score_board_right.draw_score(score_right)

  #カメラが座標(0,0,0)を見続ける
  camera.look_at(Mittsu::Vector3.new(0, 0, 0))

  # シーンとカメラの追加を行う処理
  renderer.render(scene, camera)
end
