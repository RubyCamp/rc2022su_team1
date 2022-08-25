# 攻撃側プレイヤーが地表に爆弾を到達させた際に獲得する点数を表示するためのクラス
class ScoreBoard
	# スプライトの集合体（得点板そのもの）へのアクセサ
	attr_reader :container

	# コンストラクタ
	# * x, y: 得点板を表示する座標（3Dシーン内のX-Y平面上の座標を指定する）
	# ※ 得点板はスプライトで表現するため、Z座標は気にする必要が無い。
	def initialize(x:, y:, z:)
		@x, @y, @z = x, y, z
		@container = Mittsu::Object3D.new()
		@sprites = []
		@prev_score = -Float::INFINITY

		# 0～9までの数字を表現するためのマテリアルオブジェクトを定義
		@materials = {
			mat_0: Mittsu::SpriteMaterial.new(map: MeshFactory.get_texture('textures/sprite0.png')),
			mat_1: Mittsu::SpriteMaterial.new(map: MeshFactory.get_texture('textures/sprite1.png')),
			mat_2: Mittsu::SpriteMaterial.new(map: MeshFactory.get_texture('textures/sprite2.png')),
			mat_3: Mittsu::SpriteMaterial.new(map: MeshFactory.get_texture('textures/sprite3.png')),
			mat_4: Mittsu::SpriteMaterial.new(map: MeshFactory.get_texture('textures/sprite4.png')),
			mat_5: Mittsu::SpriteMaterial.new(map: MeshFactory.get_texture('textures/sprite5.png')),
			mat_6: Mittsu::SpriteMaterial.new(map: MeshFactory.get_texture('textures/sprite6.png')),
			mat_7: Mittsu::SpriteMaterial.new(map: MeshFactory.get_texture('textures/sprite7.png')),
			mat_8: Mittsu::SpriteMaterial.new(map: MeshFactory.get_texture('textures/sprite8.png')),
			mat_9: Mittsu::SpriteMaterial.new(map: MeshFactory.get_texture('textures/sprite9.png')),
		}
	end

	# 与えられたスコアを得点板に表示する
	def draw_score(score)
		return if @prev_score == score
		x = @x
		remove_exists_sprites
		formatted_score = "%04d" % score
		formatted_score.split(//).each do |num|
			sprite = generate_sprite(num, x, @y, @z)
			@sprites << sprite
			@container.add(sprite)
			x += 1
		end
		@prev_score = score
	end

	private

	# 得点板を書き換えるために一度全スプライトをコンテナオブジェクトから消す
	def remove_exists_sprites
		@sprites.each do |sprite|
			@container.remove(sprite)
		end
		@sprites = []
	end

	# コンテナオブジェクトに数字1文字を貼り付けたスプライトを登録する
	# ※ このスプライトを4つ横に並べて得点板を表現している
	def generate_sprite(number, x, y, z)
		mat = @materials["mat_#{number}".to_sym]
		sprite = Mittsu::Sprite.new(mat)
		sprite.position.x = x
		sprite.position.y = y
		sprite.position.z = z
		sprite
	end
end