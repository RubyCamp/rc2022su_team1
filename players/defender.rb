require_relative 'base'

module Players
	# 守備側プレイヤーを定義するクラス
	class Defender < Base
		INTERCEPTABLE_DISTANCE = 1.5 # 攻撃側の爆弾に対して「接触」したと判定される距離

		# コンストラクタ
		def initialize(level: 0)
			# キャラクタの3D形状を定義する情報。MeshFactoryクラスに渡される
			attr = {
				geom_type: :box,
				mat_type: :phong,
				color: 0x0000ff
			}
			super(x: 0, y: level, z: 0, mesh_attr: attr)

			# 交差判定用Raycasterの向きを決定する単位ベクトルを生成する
			@norm_vector = Mittsu::Vector3.new(0, 1, 0).normalize

			# 交差判定用のRaycasterオブジェクトを生成する
			@raycaster = Mittsu::Raycaster.new
		end

		# キャラクタの移動に使用されるキーの定義
		def control_keys
			[
				:k_a,  # 左移動
				:k_d,  # 右移動
				:k_w,  # 上移動
				:k_s   # 下移動
			]
		end

		# 1フレーム分の進行処理
		def play(key_statuses, selected_mode)
			# キーの押下状況に応じてX-Z平面を移動する。
			self.mesh.position.x -= 0.1 if key_statuses[control_keys[0]]
			self.mesh.position.x += 0.1 if key_statuses[control_keys[1]]
			self.mesh.position.z -= 0.1 if key_statuses[control_keys[2]]
			self.mesh.position.z += 0.1 if key_statuses[control_keys[3]]
		end

		# 爆弾迎撃メソッド。
		def intercept_bombs(bombs = [])
			intercepted_bombs = []
			bomb_map = {}
			bombs.each do |bomb|
				bomb_map[bomb.mesh] = bomb
			end
			meshes = bomb_map.keys
			@raycaster.set(self.mesh.position, @norm_vector)
			collisions = @raycaster.intersect_objects(meshes)
			if collisions.size > 0
				obj = collisions.first[:object] # 最も近距離にあるオブジェクトを得る
				if meshes.include?(obj)
					# 当該オブジェクトと、当たり判定元オブジェクトの位置との距離を測る
					distance = self.mesh.position.distance_to(obj.position)
					if distance <= INTERCEPTABLE_DISTANCE
						intercepted_bombs << bomb_map[obj]
					end
				end
			end
			intercepted_bombs
		end
	end
end
