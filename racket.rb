require 'mittsu'
#TODO アイテム考慮して、外部から引数を受け取れるように設計

scene = Mittsu::Scene.new
camera = Mittsu::PerspectiveCamera.new(75.0, 1.333, 0.1, 1000.0)
camera.position.z = 2
renderer = Mittsu::OpenGLRenderer.new width: 800, height: 600, title: 'RubyCamp 2022 team01'

# ラケット１
racket1_width = 0.2
racket1_height = 2
racket1_depth = 2

geom1 = Mittsu::BoxGeometry.new(racket1_width, racket1_height, racket1_depth)
mat1 = Mittsu::MeshPhongMaterial.new(color: 0xff0000)
mesh1 = Mittsu::Mesh.new(geom1, mat1)
scene.add(mesh1)

# ラケット２
racket2_width = 0.2
racket2_height = 2
racket2_depth = 2

geom2 = Mittsu::BoxGeometry.new(racket2_width, racket2_height, racket2_depth)
mat2 = Mittsu::MeshPhongMaterial.new(color: 0x0000ff)
mesh2 = Mittsu::Mesh.new(geom2, mat2)
scene.add(mesh2)

# ボール
boll_radius = 0.1
boll_width_segments = 8
boll_height_segments = 8

geom3 = Mittsu::SphereGeometry.new(boll_radius, boll_width_segments, boll_height_segments)
mat3 = Mittsu::MeshPhongMaterial.new(color: 0x00ff00)
mesh3 = Mittsu::Mesh.new(geom3, mat3)
scene.add(mesh3)

# 位置調整
mesh1.position.z = -4
mesh1.position.x = 2
mesh2.position.z = -4
mesh2.position.x = -2
mesh3.position.z = -4
mesh3.position.x = -2

# x軸を正向きに進むか負の向きに進むかのフラグ
distance_Flag = 0

# ラケットとボールが接触したと判定する距離
contact_distance = ((racket1_width + racket2_width)/2).to_f

renderer.window.run do
    # ラケットとボールの間の距離を計算
    distance1 = mesh1.position.distance_to(mesh3.position)
    distance2 = mesh2.position.distance_to(mesh3.position)

    if distance_Flag == 0
        # racket1にボールが近づく
        mesh3.position.x += 0.03
    else
        # racket2にボールが近づく
        mesh3.position.x -= 0.03
    end

    # 得られた距離が、互いのwidthの合計値以下になったら触れたと判定する
    if distance1 <= contact_distance
        distance_Flag = 1
    elsif distance2 <= contact_distance
        distance_Flag = 0
    end
renderer.render(scene, camera)
end