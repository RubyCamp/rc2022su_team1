require_relative 'base'

module Directors
	# ゲーム本編のシーン制御用ディレクタークラス
	class Game < Base
		attr_accessor :selected_mode

		VS_COM_MODE = "com"
		VS_PLAYER_MODE = "player"

		ATTACKER_LEVEL = 8    # 攻撃側プレイヤーの「高度」（Y座標値）
		DEFENDER_LEVEL = -8   # 防御側プレイヤーの「高度」（Y座標値）
		GROUND_LEVEL = -9     # 地面オブジェクトの「高度」（Y座標値）
		GROUND_SIZE = 50.0    # 地面オブジェクトの広がり（面積）。地面オブジェクトは正方形のBoxで表現する

		# コンストラクタ
		def initialize(renderer:, aspect:)
			# スーパークラスのコンストラクタ実行
			super

			# ゲームモード（対人・対COMの選択）のデフォルトを定義
			self.selected_mode = VS_COM_MODE

			# SkyBoxをシーンに追加する
			@skybox = SkyBox.new
			self.scene.add(@skybox.mesh)

			# 光源をシーンに追加する
			add_lights

			# 地面を表現するオブジェクトを生成してシーンに登録
			@ground = Ground.new(size: GROUND_SIZE, level: GROUND_LEVEL)
			self.scene.add(@ground.mesh)

			# 攻撃側（上側）、防御側（下側）のそれぞれのプレイヤーキャラクタを生成
			@players = []
			@players << Players::Attacker.new(level: ATTACKER_LEVEL)
			@players << Players::Defender.new(level: DEFENDER_LEVEL)

			# 各プレイヤーのメッシュをシーンに登録
			@players.each{|player| self.scene.add(player.mesh) }

			# 攻撃側が落とす爆弾の保存用配列を初期化
			@bombs = []

			# 攻撃側プレイヤーの獲得スコアの初期化
			@score = 0
		end

		# 1フレーム分のゲーム進行処理
		def render_frame
			@players.each do |player|
				key_statuses = check_key_statuses(player)
				player.play(key_statuses, self.selected_mode)
				add_bombs(player.collect_bombs)
				intercept(player)
			end
			erase_bombs
			self.camera.draw_score(@score)
		end

		private

		# 爆弾迎撃処理
		def intercept(player)
			removed_bombs = player.intercept_bombs(@bombs)
			removed_bombs.each{|bomb| self.scene.remove(bomb.mesh) }
			@bombs -= removed_bombs
		end

		# 地面（Ground）レベルまで落下した爆弾の消去処理
		def erase_bombs
			removed_bombs = Bomb.operation(@bombs, GROUND_LEVEL)
			removed_bombs.each{|bomb| self.scene.remove(bomb.mesh) }
			@bombs -= removed_bombs
			@score += removed_bombs.size
		end

		# シーンに爆弾を追加
		def add_bombs(bombs)
			bombs.each do |bomb|
				self.scene.add(bomb.mesh)
				@bombs << bomb
			end
		end

		# プレイヤーが必要とするキーの押下情報をハッシュ形式にまとめる。
		def check_key_statuses(player)
			result = {}
			player.control_keys.each do |key|
				result[key] = key_down?(key: key)
			end
			result
		end

		# カメラ視点操作用イベントハンドラ（マウスクリック検知）オーバーライド
		# これらのイベントハンドラメソッドの元はBaseクラスに定義しているので、必要に応じて参照してください。
		#
		# ※ Forwardableモジュールを用いてcameraオブジェクトにdelegate(移譲)するとよりシンプルに記述可能です。
		#    興味のある人は https://ruby-doc.org/stdlib-2.7.1/libdoc/forwardable/rdoc/Forwardable.html などを参照。
		#    require 'forwardable'
		#    とした上で、
		#    ````
		#    extend Forwardable
		#    delegate mouse_clicked: :camera
		#    ````
		#    のように移譲すればこのメソッドは記述しなくてもよくなる。
		def mouse_clicked(button:, position:)
			self.camera.mouse_clicked(button: button, position: position)
		end

		# カメラ視点操作用イベントハンドラ（マウスホイールのスクロール検知）オーバーライド
		def mouse_wheel_scrolled(offset:)
			self.camera.mouse_wheel_scrolled(offset: offset)
		end

		# カメラ視点操作用イベントハンドラ（マウスカーソルの移動検知）オーバーライド
		# ※ このメソッドは、Base#mouse_button_down?を使っているので単純にdelegateはできない（無理ではないが大変）点に注意。
		def mouse_moved(position:)
			if mouse_button_down?
				self.camera.mouse_moved(position: position)
			end
		end

		# シーンに光源を追加
		def add_lights
			light = Mittsu::PointLight.new(0xffffff)
			light.position.set(1, 7, 1)
			self.scene.add(light)
		end
	end
end
