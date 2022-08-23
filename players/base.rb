# プレイヤーキャラクタを束ねるためのモジュール
module Players
	# 攻撃側・守備側双方のプレイヤーに共通する性質を定義するベースクラス
	class Base
		# プレイヤーキャラクタを表現する3D形状（Mesh）へのアクセサ
		attr_accessor :mesh

		# コンストラクタ
		# * x, y, z: プレイヤーキャラクタの3D空間内での初期座標
		# * mesh_attr: MeshFactoryに渡す3D形状の定義情報
		def initialize(x:, y:, z:, mesh_attr:)
			self.mesh = MeshFactory.generate(mesh_attr)
			self.mesh.position.x = x
			self.mesh.position.y = y
			self.mesh.position.z = z
		end

		# 当該プレイヤーキャラクタの操作に使用するキーのリスト。
		# 個別のプレイヤークラスでオーバーライドする。
		# ※ 値は glfw_helper.rb#GLFW_CONSTS 参照。
		def control_keys
			[]
		end

		# 1フレーム分の挙動を定義する。
		# 具体的実装は個別クラスにて行うため、ここでは何も定義しない。
		# 引数「key_statuses」（Hash）には、glfw_helper.rb#GLFW_CONSTS に定義されるキーを表すシンボルと、
		# その状態（true: 押下中、false: リリース中）が保持されている。
		# 同ハッシュのkeyは、「control_keys」で返す値が採用されている。
		# 例）
		# {
		#   k_num4: true,
		#   k_num6: false,
		#   k_num8: true,
		#   k_num2: false,
		#   ...
		# }
		def play(key_statuses, selected_mode)
			raise "override me"
		end

		# 爆弾回収用メソッド。
		# ディレクターオブジェクトから呼ばれ、当該プレイヤーが保持している爆弾を回収する。
		# 共通クラスでは何も動作しない(空配列を返す)ようにしておき、個別クラスで必要に応じて定義を上書きする。
		# ※ 今回は防御側プレイヤーは爆弾を生成しない仕様にしているため。
		def collect_bombs
			[]
		end

		# 爆弾迎撃メソッド。
		# 防御側プレイヤークラスでオーバーライドし、爆弾を地面（Ground）に到達する前に迎撃（爆弾と防御プレイヤーを重ねる）
		# できているか判定する。
		def intercept_bombs(bombs = [])
			[]
		end
	end
end
