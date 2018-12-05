## 【Swift4】ジェスチャー 機能を用いたUIImageViewのドラッグ機能の実装



<h2>今回作成するもの</h2>

* ボタンを押すとオブジェクトを作成
* タッチで画像を大きくなり、ドラッグで画像が動き、離して元の大きさに戻す
* 長押しで削除。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">【iOSアプリ開発】<br>以下機能のサンプルアプリ<br><br>●ボタンを押すとペンギンの画像を表示する機能<br><br>●画像をドラッグする機能<br><br>●画像の長押しで削除する機能 <a href="https://t.co/rixL2qLGqF">pic.twitter.com/rixL2qLGqF</a></p>&mdash; とがみん@ブロガーinセブエンジニア (@togaminnnn) <a href="https://twitter.com/togaminnnn/status/1063245502001500161?ref_src=twsrc%5Etfw">2018年11月16日</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<h2>実装手順</h2>

<h3>ペンギンアイコンの表示</h3>

ボタンが押されると、ペンギンの画像が画面中央に表示されるプログラムを書きます。

`UIButton`を配置し、ボタンが押された時に動作する関数の中に、以下のコードを書きます。

```swift
//UIImageViewのインスタンス化
var penguinImageView = UIImageView()
//画像の代入
penguinImageView.image = UIImage(named: "penguin.png")
//ImageViewのサイズ・位置を指定
penguinImageView.frame.size.width = 100
penguinImageView.frame.size.height = 100
penguinImageView.center = view.center
//ImageViewに縦横の比率を保ったまま画像がおさまるようにする。
penguinImageView.contentMode = UIView.ContentMode.scaleAspectFit
//viewにImageViewを配置
view.addSubview(penguinImageView)
```

上記のコードを記述することによって、ボタンを押すたびに、ペンギンの画像が画面中央に表示されるようになります。

<h3>UIImageView画像をドラッグする機能の実装</h3>

次に`UIImageView`のドラッグ機能を実装します。

この機能を実装するに当たって、
<ol><li>画面がタッチされたときに呼ばれる関数</li><li>画面をドラッグした時に呼ばれる関数</li><li>ドラッグ終了時、画面のタッチを終了した時に呼ばれる関数</li></ol>

の3つを使います。

```swift
// 画面のタッチ時に呼ばれる
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
 
//ドラッグ時に呼ばれる
override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
 
//ドラッグ終了時に呼ばれる
override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}

```

<h4>画面タッチ時</h4>

画面のタッチ時、タッチした位置に`UIImageView`があるかどうかを確かめます。

`UIImageView`がタッチされたかどうかの判定に`tag`を使います。`UIImageView`を生成する場所に以下のコードを追加します。

また、ユーザの操作に対して、UIImageViewが反応するように、その設定も追加します。

```swift
//タッチしたものがUIImageViewかどうかを判別する用のタグ
penguinImageView.tag = 1
//ユーザーの操作に反応するようにする
penguinImageView.isUserInteractionEnabled = true
```

次に、画面がタッチされた時に呼ばれる関数の中に、以下のコードを記述します。

```swift
//画面をタッチした時に呼ばれる関数
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
	//一番初めにタッチしたものだけ取得。
	if let touch = touches.first{
	//タッチしたViewを取得
    	let touchView = touch.view
       	//タッチしたViewのタグがい「1」なら、そのViewの中心をタッチした位置に移動する。
    	if touchView?.tag == 1{
          	touchView?.frame.size.width = 120
            touchView?.frame.size.height = 120
           	touchView?.center = touch.location(in: view)
       	}
    }
}
```

画面がタッチされた時に、一番初めにタップされた`View`を取得。そのタグを確認し、「1」であれば、そのサイズを大きくし、タッチした位置にその`View`を移動します。

<h4>画面移動時(ドラッグ時)</h4>

画面移動時、ドラッグ時は、移動に合わせて、タッチした`View`が移動するようにします。

この時、画面タッチ時と同じ処理を行うので、ドラッグ時に呼ばれる関数に以下のようにコードを記述します。

```swift
//ドラッグ時に呼ばれる
override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
	//画面タッチ時に呼ばれる関数と同じ処理を実行。
    self.touchesBegan(touches, with: event)
}
```

<h4>ドラッグ終了時</h4>

ドラッグ終了時、画像のサイズをもとに戻します。

```swift
//ドラッグ終了時に呼ばれる
override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
 	touches.first?.view?.frame.size.width = 100
    touches.first?.view?.frame.size.height = 100
}
```

<h3>長押しで削除する機能の実装</h3>

画像を長押しした時に、削除する機能を追加します。

長押し機能の実装には`UILongPressGestureRecognizer()`を使います。以下の変数を宣言し、`UILongPressGestureRecognizer()`をインスタンス化します。

```swift
var longGesture = UILongPressGestureRecognizer()
```

生成した`UIImageView`に`UILongPressGestureRecognizer()`を追加したいので、ボタンを押し`UIImageView`を生成した後の部分に以下のコードを追加します。

```swift
//どのターゲットを長押しした時に、どの関数を実行するかを指定。今回は「longPress関数」を実行する。
longGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPress(_:)))
//関数が実行されるまでの長押しする時間
longGesture.minimumPressDuration = 0.5
//viewにジェスチャー機能を追加
penguinImageView.addGestureRecognizer(longGesture)
```

 `longPress関数`を書きます。長押しされた時に、長押しされた`View`を削除するコードを書きます。



```swift
//長押しされた時に呼び出される。
@objc func longPress(_ sender: UILongPressGestureRecognizer) {
    sender.view!.removeFromSuperview()
}
```

これで実行すると、生成した画像を長押しすることによって削除することができます。

<h2>GitHub</h2>

サンプルコードはGitHubにあげています。参考にしながら実装してみてください。

<a href = "https://github.com/togamin/gestureSample.git">＞http:////github.com/togamin/gestureSample.git</a>


<h2>まとめ</h2>

タッチジェスチャー 機能、ロングプレスジェスチャー機能を用いて簡単なアプリケーションを実装しました。



