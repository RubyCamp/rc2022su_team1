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
mat1 = Mittsu::MeshBasicMaterial.new(color: 0xff0000)
mesh1 = Mittsu::Mesh.new(geom1, mat1)
scene.add(mesh1)

# ラケット２
racket2_width = 0.2
racket2_height = 2
racket2_depth = 2

geom2 = Mittsu::BoxGeometry.new(racket2_width, racket2_height, racket2_depth)
mat2 = Mittsu::MeshBasicMaterial.new(color: 0x0000ff)
mesh2 = Mittsu::Mesh.new(geom2, mat2)
scene.add(mesh2)

# ボール
boll_radius = 0.1
boll_width_segments = 8
boll_height_segments = 8

geom3 = Mittsu::SphereGeometry.new(boll_radius, boll_width_segments, boll_height_segments)
mat3 = Mittsu::MeshBasicMaterial.new(color: 0x00ff00)
mesh3 = Mittsu::Mesh.new(geom3, mat3)
scene.add(mesh3)

#アイテム
items = []
3.times do
item_radius = 0.1
item_width_segments = 8
item_height_segments = 8

geom4 = Mittsu::SphereGeometry.new(item_radius, item_width_segments, item_height_segments)
mat4 = Mittsu::MeshBasicMaterial.new(color: 0xffff00)
mesh4 = Mittsu::Mesh.new(geom4, mat4)
scene.add(mesh4)
items << mesh4
end

#障害物
wall_width = 5
wall_height = 5
wall_depth = 2

geom5 = Mittsu::BoxGeometry.new(wall_width, wall_height, wall_depth)
mat5 = Mittsu::MeshBasicMaterial.new(color: 0xffffff)
mesh5 = Mittsu::Mesh.new(geom5, mat5)



# 位置調整
mesh1.position.z = -4
mesh1.position.x = 2
mesh2.position.z = -4
mesh2.position.x = -2
mesh3.position.z = -4
mesh3.position.x = -2
#障害物の位置
mesh5.position.z = 0
mesh5.position.x = 0
#アイテムの位置
items[0].position.x = 0
items[0].position.z = -4
items[1].position.x = -1
items[1].position.z = -4
items[2].position.x = 1
items[2].position.z = -4

# x軸を正向きに進むか負の向きに進むかのフラグ
distance_Flag = 0

# ラケットとボールが接触したと判定する距離
contact_distance = ((racket1_width + racket2_width)/2).to_f
# ボールとアイテムが接触したと判定する距離
contact_distance2 = 1.5
#アイテムを取得した時間
item_time = []

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
    #アイテムの処理
    items.each_with_index do |item,index|
        distance = items[index].position.distance_to(mesh3.position)
        case index
        when 0
            #ボールの大きさを変える処理
            if distance <= contact_distance2
                item_time[0] ||= Time.now
                mesh3.scale.set(10,10,10)
                # アイテムを消す
               scene.remove(item)
            end
            #ボールの効果時間が過ぎたら
            if item_time[0]
             if (Time.now - item_time[0]) >= 10
                # ボールの大きさを変える
                mesh3.scale.set(1,1,1)
             end
            end
        when 1
            #ラケットの大きさを変える処理
            if distance <= contact_distance2
                item_time[1] ||= Time.now
                mesh1.scale.set(10,10,10)
                # アイテムを消す
               scene.remove(item)
            end
            #ラケットの効果時間が過ぎたら
            if item_time[1]
                if (Time.now - item_time[1]) >= 10
                   # ラケットの大きさを変える
                   mesh1.scale.set(1,1,1)
                end
               end
        when 2
            #障害物を表示する
            if distance <= contact_distance2
                item_time[2] ||= Time.now
                #障害物を表示する
                scene.add(mesh5)

                # アイテムを消す
               scene.remove(item)
            end
            #障害物の効果時間が過ぎたら
            if item_time[2]
                if (Time.now - item_time[2]) >= 10
                   # 障害物を消す
                   scene.remove(mesh5)
                end
               end
        end
        
    end
    

    # 得られた距離が、互いのwidthの合計値以下になったら触れたと判定する
    if distance1 <= contact_distance
        distance_Flag = 1
    elsif distance2 <= contact_distance
        distance_Flag = 0
    end
renderer.render(scene, camera)
end
