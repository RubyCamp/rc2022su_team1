require_relative 'base'

module Players
	# 攻撃側プレイヤーを定義するクラス
	class Attacker < Base
		BOMBING_INTERVAL = 30  # 投弾可能になるまでのインターバル（単位: フレーム数）

		# 移動可能範囲の定義（対COMの場合にのみ適用）
		X_RANGE = (-5..5).to_a
		Z_RANGE = (-5..5).to_a

		# 移動方向変更までのフレーム数
		CHANGE_DIRECTION_INTERVAL = 60

		# キャラクタの移動スピード
		SPEED = 0.1

		# コンストラクタ
		def initialize(level: 0)
			# キャラクタの3D形状を定義する情報。MeshFactoryクラスに渡される
			attr = {
				geom_type: :box,
				mat_type: :phong,
				color: 0x00ff00
			}
			super(x: 0, y: level, z: 0, mesh_attr: attr)

			# 投弾間隔を制御するためのタイマー変数を初期化する。
			# NOTE: 同タイマー変数がBOMBING_INTERVALに達していれば投下可能と定義する。
			@bomb_timer = BOMBING_INTERVAL

			# 1フレームにおいて投下した爆弾を格納する配列を初期化
			@bombs = []

			# 移動方向変更までの猶予フレーム数カウンター初期化
			@change_direction_counter = CHANGE_DIRECTION_INTERVAL

			# 移動方向を表す2次元ベクトル
			@direction = Mittsu::Vector2.new(0, 0)
		end

		# キャラクタの移動に使用されるキーの定義
		def control_keys
			[
				:k_left,  # 左移動
				:k_right,  # 右移動
				:k_up,  # 上移動
				:k_down,  # 下移動
				:k_enter   # 爆弾投下
			]
		end

		# 1フレーム分の進行処理
		def play(key_statuses, selected_mode)
			# ゲームモードに応じてキャラクタの移動方法を選択する
			case selected_mode
			when Directors::Game::VS_COM_MODE
				# CPUによるランダム移動
				random_move
			else
				# 人間の手によるキーボード操作
				move_by_keyboard(key_statuses)
			end
			# タイマー変数がBOMBING_INTERVAL未満の場合はカウント増加
			@bomb_timer += 1 if @bomb_timer < BOMBING_INTERVAL
		end

		# 爆弾回収用メソッド。
		# 本メソッドはディレクターオブジェクトから呼ばれ、その時点で投下済みの爆弾を回収する。
		def collect_bombs
			result = @bombs.dup # 回収される爆弾を取り出す
			@bombs.clear # 爆弾保管用配列をクリアする
			result
		end

		private

		# COM対戦モード用の移動処理
		def random_move
			# 移動方向の決定
			decision_direction if @change_direction_counter == CHANGE_DIRECTION_INTERVAL

			# 移動実行
			# ※ 移動可能範囲を逸脱する場合はその場に留まる。
			next_x = self.mesh.position.x + @direction.x
			next_z = self.mesh.position.z + @direction.y
			self.mesh.position.x += @direction.x if X_RANGE.include?(next_x.to_i)
			self.mesh.position.z += @direction.y if Z_RANGE.include?(next_z.to_i)

			# 爆弾投下判定（ランダム投下）
			bomb_flag = rand(300)
			bombing if bomb_flag == 1

			# 移動方向変更用カウンターの更新
			@change_direction_counter += 1 if @change_direction_counter < CHANGE_DIRECTION_INTERVAL
		end

		# 移動方向の決定処理
		# ※ 2次元ベクトルで移動方向を表現する。これによって斜め方向の移動も可能となる。
		def decision_direction
			dir_x = rand(3) - 1
			dir_y = rand(3) - 1
			@direction = Mittsu::Vector2.new(dir_x * SPEED, dir_y * SPEED)
			@change_direction_counter = 0
		end

		# 対人モード用の移動処理
		def move_by_keyboard(key_statuses)
			# キーの押下状況に応じてX-Z平面を移動する。
			self.mesh.position.x -= SPEED if key_statuses[control_keys[0]]
			self.mesh.position.x += SPEED if key_statuses[control_keys[1]]
			self.mesh.position.z -= SPEED if key_statuses[control_keys[2]]
			self.mesh.position.z += SPEED if key_statuses[control_keys[3]]

			# 爆弾投下キーが押下され、且つ爆撃準備完了（タイマー変数がBOMBING_INTERVAL分まで回復）している場合、
			# 爆撃を実行する。
			bombing if key_statuses[control_keys[4]] && can_be_thrown?
		end

		# 爆弾投下可否を返す
		def can_be_thrown?
			@bomb_timer == BOMBING_INTERVAL
		end

		# 爆撃実行。
		# 1回の爆撃実行で1発の爆弾を投下する。
		# 投下後、タイマー変数をクリアし、次の爆弾投下可能になるまでのカウントを開始する。
		# NOTE: ここで複数個爆弾オブジェクトを生成すれば、1フレームで複数個の爆弾を投下することも可能となる。
		def bombing
			@bombs << Bomb.new(pos: self.mesh.position)
			@bomb_timer = 0
		end
	end
end
