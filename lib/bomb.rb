require_relative 'mesh_factory'

# 攻撃側プレイヤーが投下する爆弾を表現するクラス
class Bomb
	# 爆弾の3D形状（メッシュ）へのアクセサ
	attr_reader :mesh

	# 与えられたBombオブジェクトの配列について、それぞれ1フレーム分動かした上でシーンから抹消されるべき個体を配列で返す。
	def self.operation(bombs, ground_level)
		removed_bombs = []
		bombs.each do |bomb|
			removed = bomb.move(ground_level)
			removed_bombs << bomb if removed
		end
		return removed_bombs
	end

	# コンストラクタ
	# pos: 爆弾を出現させる初期位置となる座標（Vector3オブジェクト）
	def initialize(pos:)
		# 爆弾の3D形状を生成
		@mesh = MeshFactory.generate(
			geom_type: :sphere,
			mat_type: :phong,
			radius: 0.5,
			color: 0xffffff
		)

		# 爆弾の初期位置に対して、Y軸を1.0降ろして爆弾の初期座標を決定する。
		# ※ 引数posには攻撃側プレイヤーの座標がそのまま渡されてくることを前提するため、初期位置が重ならないようにする。
		# NOTE: Meshのpositionを他のVector3オブジェクトと同じにするには、copyメソッドを使ってVector3オブジェクトを複製
		#       して利用する点に注意。
		@mesh.position.copy(pos)
		@mesh.position.y -= 2.0
	end

	# 爆弾を1フレーム分移動させる。
	# 引数ground_levenは、爆弾が到達できる下限となるY座標値（そこがGround、つまり地表という意味になる）
	def move(ground_level)
		@mesh.position.y -= 0.1
		@mesh.position.y <= ground_level
	end
end
