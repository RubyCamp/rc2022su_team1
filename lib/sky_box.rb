# スカイボックス用クラス
class SkyBox
	# 3D形状へのアクセサ
	attr_reader :mesh

	# コンストラクタ
	# いわゆる「Cubeマップ」を用いて立方体の内面にテクスチャを貼り付け、疑似的なスカイボックスにしている。
	# ※ サンプルは「スカイ」ではなく単なる格子状のテクスチャだが、便宜上スカイボックスと呼称する。
	def initialize
		texture = Mittsu::ImageUtils.load_texture_cube(
			[ 'rt', 'lf', 'up', 'dn', 'bk', 'ft' ].map { |path|
				"textures/sky_#{path}.png"
			}
		)
		shader = Mittsu::ShaderLib[:cube]
		shader.uniforms['tCube'].value = texture
		skybox_material = Mittsu::ShaderMaterial.new({
			fragment_shader: shader.fragment_shader,
			vertex_shader: shader.vertex_shader,
			uniforms: shader.uniforms,
			depth_write: false,
			side: Mittsu::BackSide
	  })
		@mesh = Mittsu::Mesh.new(Mittsu::BoxGeometry.new(100, 100, 100), skybox_material)
	end
end