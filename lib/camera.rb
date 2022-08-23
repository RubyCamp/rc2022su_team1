require_relative 'score_board'
require 'forwardable'

# Mittsuのカメラクラスをラッピングしたカメラ制御用クラス
class Camera
	extend Forwardable # delegateを用いるための準備

	attr_reader :container, :instance

	# 定数類の定義（デフォルト値として利用）
	DEFAULT_FOV = 75.0
	DEFAULT_NEAR = 0.1
	DEFAULT_FAR = 1000.0
	DEFAULT_Z_POS = 15.0

	# X・Y軸を表す単位ベクトルを定義
	X_AXIS = Mittsu::Vector3.new(1.0, 0.0, 0.0)
	Y_AXIS = Mittsu::Vector3.new(0.0, 1.0, 0.0)

	# 得点のカウントをScoreBoardオブジェクトにdelegate（移譲）する
	delegate draw_score: :@score_board

	# コンストラクタ
	# 得点表示用スプライト（ScoreBoard）やMittsuのPerspectiveCameraオブジェクトなど、必要な初期化を行う。
	# Mittsuのカメラはコンテナ（Mittsu::Object3D）という空オブジェクトに紐づけてシーンに追加して運用する。
	# カメラは必ずしもシーンに追加しなくても使えるが、こうすることでマウスドラッグによる視点回転などを表現しやすくする。
	def initialize(aspect: , fov: DEFAULT_FOV, near: DEFAULT_NEAR, far: DEFAULT_FAR, initial_z_pos: DEFAULT_Z_POS)
		@score_board = ScoreBoard.new(x: -14, y: 10)
		@instance = Mittsu::PerspectiveCamera.new(fov, aspect, near, far)
		@instance.position.z = initial_z_pos
		@container = Mittsu::Object3D.new
		@container.add(self.instance)
		@container.add(@score_board.container)
		@mouse_delta = Mittsu::Vector2.new
		@last_mouse_position = Mittsu::Vector2.new
	end

	# マウスボタンがクリックされた際の挙動を定義
	# 左ボタンのクリックで、視点回転を開始する。
	def mouse_clicked(button:, position:)
		if button == :m_left
			@last_mouse_position.copy(position)
		end
	end

	# マウスホイールのスクロール時の挙動を定義
	# ホイールスクロールで視点を拡大・縮小できるようにする。
	def mouse_wheel_scrolled(offset:)
		scroll_factor = (1.5 ** (offset.y * 0.1))
		@instance.zoom *= scroll_factor
		@instance.update_projection_matrix
	end

	# マウスカーソルの移動検知時の挙動を定義
	# マウスの左ドラッグで視点の自由回転ができるようにする。
	def mouse_moved(position:)
		@mouse_delta.copy(@last_mouse_position).sub(position)
		@last_mouse_position.copy(position)
		@container.rotate_on_axis(Y_AXIS, @mouse_delta.x * 0.01)
		@container.rotate_on_axis(X_AXIS, @mouse_delta.y * 0.01)
	end

	# カメラオブジェクトの位置を変更する（絶対指定）
	def set_position(x: nil, y: nil, z: nil)
		@instance.position.x = x if x
		@instance.position.y = y if y
		@instance.position.z = z if z
	end

	# カメラオブジェクトの位置を変更する（相対指定）
	def move(x: nil, y: nil, z:nil)
		@instance.position.x += x if x
		@instance.position.y += y if y
		@instance.position.z += z if z
	end

	# カメラオブジェクトの回転を変更する（絶対指定）
	def set_rotation(x: nil, y: nil, z: nil)
		@instance.rotation.x = x if x
		@instance.rotation.y = y if y
		@instance.rotation.z = z if z
	end

	# カメラオブジェクトの回転を変更する（相対指定）
	def rotate(x: nil, y: nil, z: nil)
		@instance.rotation.x += x if x
		@instance.rotation.y += y if y
		@instance.rotation.z += z if z
	end

	# カメラオブジェクトの注視点を指定する
	def look_at(x: 0.0, y: 0.0, z: 0.0)
		@instance.look_at(Mittsu::Vector3.new(x, y, z))
	end

	# Mittsuのカメラオブジェクトの現在位置を返す
	def position
		@instance.position
	end

	# Mittsuのカメラオブジェクトの現在の回転情報を返す
	def rotation
		@instance.rotation
	end
end