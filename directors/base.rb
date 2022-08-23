# シーンの管理を担当するディレクタークラスを束ねるモジュール
module Directors
	# ディレクタークラスの共通基盤となるベースクラス
	class Base
		# OpenGLの関連定数などをラッピングするモジュールをMix-Inする
		include GlfwHelper

		# Mittsuのシーンオブジェクトと、Mittsuのカメラオブジェクト（のラッピング）へのアクセサを定義する
		attr_accessor :scene, :camera, :next_director

		# コンストラクタ
		# カメラのアスペクト比等を決定し、レンダラーやイベントハンドラを定義する
		def initialize(renderer:, aspect:, camera: nil)
			@renderer = renderer
			camera = Camera.new(aspect: aspect) unless camera
			self.scene = Mittsu::Scene.new
			self.camera = camera
			self.scene.add(camera.container)

			# 次フレームの描画を担当する「next_director」アクセサの初期値をself（このディレクター自身）に
			# セットしておく
			self.next_director = self
		end

		# Mittsuのイベントをラッピングし、イベントハンドラメソッドを定義する
		def activate_events
			# ウィンドウリサイズ
			@renderer.window.on_resize do |width, height|
				@renderer.set_viewport(0, 0, width, height)
				self.camera.instance.aspect = width.to_f / height.to_f
				self.camera.instance.update_projection_matrix
				resized(width: width, height: height)
			end

			# マウスクリック
			# - glfw_button: GLFWで定義されたマウスボタンの整数値
			# - position: Mittsu::Vector2（position.x, position.y で座標値が得られる）
			@renderer.window.on_mouse_button_pressed do |glfw_button, position|
				mouse_clicked(button: GLFW_CONSTS_INVERTED[glfw_button], position: position)
			end

			# マウスリリース
			# - glfw_button: GLFWで定義されたマウスボタンの整数値
			# - position: Mittsu::Vector2（position.x, position.y で座標値が得られる）
			@renderer.window.on_mouse_button_released do |glfw_button, position|
				mouse_released(button: GLFW_CONSTS_INVERTED[glfw_button], position: position)
			end

			# マウスカーソルが移動した際に、その現在座標（ウィンドウ座標）を返す。
			# - マウスカーソルがレンダラーのウィンドウ座標外に出た場合は反応しない。
			# - position: Mittsu::Vector2（position.x, position.y で座標値が得られる）
			@renderer.window.on_mouse_move do |position|
				mouse_moved(position: position)
			end

			# マウスホイールを回転させた際に、その回転したオフセット値を返す。
			# - offset: Mittsu::Vector2（offset.x, offset.y で各座標軸毎の回転量が得られる）
			#   ※ 一般的なマウスでは、Y軸方向にしか回転しないので、X成分は基本0となる。
			@renderer.window.on_scroll do |offset|
				mouse_wheel_scrolled(offset: offset)
			end

			# キー入力（単発タイプ）
			# - キーボードのキーが押された際に発火する。
			#   押下した際に1回だけ反応し、押しっぱなしにしても連続的には発火しない。
			# - glfw_key: GLFWで定義されたキーボードキーを示す整数値
			# - 戻り値: glfw_helper.rb で定義されたシンボル
			@renderer.window.on_key_pressed do |glfw_key|
				key_pressed(key: GLFW_CONSTS_INVERTED[glfw_key])
			end

			# キー入力（離した際に発動するタイプ）
			# - キーボードのキーが離された際に発火する。
			#   キーを押下した後、離した際に1回だけ反応する。
			# - glfw_key: GLFWで定義されたキーボードキーを示す整数値
			# - 戻り値: glfw_helper.rb で定義されたシンボル
			@renderer.window.on_key_released do |glfw_key|
				key_released(key: GLFW_CONSTS_INVERTED[glfw_key])
			end

			# キー入力（離散タイプ）
			# - キーボードのキーが押された際に発火する。
			#   on_key_pressedと異なり、押し続ければ連続で発火する。
			#   但し、その発火タイミングは離散的であり、スムーズに押しっ放し状態を表現することはできない。
			#   押しっ放し状態を制御したい場合は、key_down? メソッドを利用する。
			# - glfw_key: GLFWで定義されたキーボードキーを示す整数値
			# - 戻り値: glfw_helper.rb で定義されたシンボル
			@renderer.window.on_key_typed do |glfw_key|
				key_typed(key: GLFW_CONSTS_INVERTED[glfw_key])
			end

			# キーボードから1文字（表示可能な文字）の入力を受付け、当該文字そのものを引数として渡す
			@renderer.window.on_character_input do |char|
				character_input(char: char)
			end
		end

		# ウィンドウのリサイズ（サイズ変更）用ハンドラ
		# 引数:
		# * width, height: リサイズ後の新しいウィンドウサイズ
		def resized(width: , height:)
			# override me.
		end

		# マウスボタンのクリックイベント用ハンドラ
		# 引数:
		# * button: その際のマウスボタンの種類（GlfwHelper参照）
		# * position: クリックされたウィンドウ座標を表すVector2オブジェクト
		def mouse_clicked(button: , position:)
			# override me.
		end

		# マウスボタンのリリースイベント用ハンドラ
		# 引数:
		# * button: その際のマウスボタンの種類（GlfwHelper参照）
		# * position: リリースされたウィンドウ座標を表すVector2オブジェクト
		def mouse_released(button: , position:)
			# override me.
		end

		# マウスボタンの移動イベント用ハンドラ
		# 引数:
		# * position: 移動後のマウスカーソルのウィンドウ座標を表すVector2オブジェクト
		def mouse_moved(position:)
			# override me.
		end

		# マウスボタンのホイールのスクロールイベント用ハンドラ
		# 引数:
		# * offset: ホイールが回転した量
		def mouse_wheel_scrolled(offset:)
			# override me.
		end

		# キーボードのキー押下イベント用ハンドラ
		# 引数:
		# * key: 押下されたキーを示す定数（GlfwHelper参照）
		def key_pressed(key:)
			# override me.
		end

		# キーボードのキーリリースイベント用ハンドラ
		# 引数:
		# * key: リリースされたキーを示す定数（GlfwHelper参照）
		def key_released(key:)
			# override me.
		end

		# キーボードのキータイプ（押して離す）イベント用ハンドラ
		# 引数:
		# * key: タイプされたキーを示す定数（GlfwHelper参照）
		def key_typed(key:)
			# override me.
		end

		# キーボードのキー入力イベント用ハンドラ
		# 引数:
		# * char: 入力されたキャラクタ（文字）そのもの
		def character_input(char:)
			# override me.
		end

		# 現在のマウスカーソルのウィンドウ座標を返す。
		# - マウスカーソルがレンダラーのウィンドウ範囲外にあっても値を返す。
		# - 戻り値はMittsu::Vector2（obj.x, obj.y で座標値が得られる）
		def mouse_position
			@renderer.window.mouse_position
		end

		# マウスボタンが押下されているか否かを返す。
		# - button: glfw_helper.rb で定義されるマウスボタンを示すシンボル（:m_left => 左ボタン, :m_right => 右ボタン）
		# - 戻り値: boolean
		def mouse_button_down?(button: :m_left)
			@renderer.window.mouse_button_down?(GLFW_CONSTS[button])
		end

		# キーボードのキーが押下されているか否かを返す。
		# - key: glfw_helper.rb で定義されるキーボードキーを示すシンボル
		# - 戻り値: boolean
		def key_down?(key:)
			@renderer.window.key_down?(GLFW_CONSTS[key])
		end

		# フレーム描画用メソッド
		# 何もしなくても1フレーム毎に呼び出される。
		# render_frameメソッド（個別ディレクターで上書きする前提）呼び出し後、next_director（次のフレームの
		# 描画を担当するディレクターオブジェクト）を呼び出し元（main.rb）に返すことでシーン制御を実現する。
		def play
			render_frame
			self.next_director
		end

		# 個々のディレクタークラスでオーバーライドする１フレーム分の描画用メソッド
		def render_frame
			# override me.
		end
	end
end
