require 'mittsu'

# 依存するファイル群を一括でrequireする
Dir.glob("lib/*.rb") {|path| require_relative path }
Dir.glob("players/*.rb") {|path| require_relative path }
Dir.glob("directors/*.rb") {|path| require_relative path }

# 画面サイズとキャプション用の定数を定義
SCREEN_WIDTH = 1024
SCREEN_HEIGHT = 768
TITLE = 'Ruby Camp 2022 Summer Example'

# レンダラーオブジェクト生成
renderer = Mittsu::OpenGLRenderer.new width: SCREEN_WIDTH, height: SCREEN_HEIGHT, title: TITLE

# カメラ用のアスペクト比を計算
aspect_ratio = SCREEN_WIDTH.to_f / SCREEN_HEIGHT.to_f

# 起動直後に実行するディレクター（タイトル画面用）オブジェクト生成
current_director = Directors::Title.new(renderer: renderer, aspect: aspect_ratio)

# メインループ開始
renderer.window.run do
	# Directors::Base#playが返してくる「next_director」アクセサの内容を次のフレームの描画を担当するディレクターに設定する。
	# これによって、各個別ディレクターオブジェクトで「next_director」アクセサを変更することでシーン遷移ができるようになる。
	current_director = current_director.play

	# １フレーム分のレンダリングを実行。
	# 描画対象となるシーンと撮影用カメラはそれぞれ現在のディレクターオブジェクトから得る。
	renderer.render(current_director.scene, current_director.camera.instance)
end
