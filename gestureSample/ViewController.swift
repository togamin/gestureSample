//
//  ViewController.swift
//  gestureSample
//
//  Created by Togami Yuki on 2018/11/14.
//  Copyright © 2018 Togami Yuki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //アイコンを追加する用の画像
    @IBOutlet weak var addIcon: UIButton!
    
    //UILongPressGestureRecognizerのインスタンス化
    var longGesture = UILongPressGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //アイコン追加のボタンのレイアウト
        addIcon.layer.frame.size.width = 70
        addIcon.layer.frame.size.width = 70
        addIcon.layer.cornerRadius = addIcon.layer.frame.size.width*0.5
        //ボタン選択じの画像を変更
        addIcon.setBackgroundImage(UIImage(named:"plus.png"), for: .normal)
        addIcon.setBackgroundImage(UIImage(named:"plus2.png"), for: .highlighted)
        
    }
    
    
    @IBAction func addIconAct(_ sender: UIButton) {
        
        //ImageViewのインスタンス化
        var penguinImageView = UIImageView()
        //画像の代入
        penguinImageView.image = UIImage(named: "penguin.png")
        //ImageViewのサイズ・位置を指定
        penguinImageView.frame.size.width = 100
        penguinImageView.frame.size.height = 100
        penguinImageView.center = view.center
        //ImageViewに縦横の比率を保ったまま画像がおさまるようにする。
        penguinImageView.contentMode = UIView.ContentMode.scaleAspectFit
        //タッチしたものがUIImageViewかどうかを判別する用のタグ
        penguinImageView.tag = 1
        //ユーザーの操作に反応するようにする
        penguinImageView.isUserInteractionEnabled = true
        
        
        //どのターゲットを長押しした時に、どの関数を実行するかを指定。今回は「longPress関数」を実行する。
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPress(_:)))
        //関数が実行されるまでの長押しする時間
        longGesture.minimumPressDuration = 0.5
        //viewにジェスチャー機能を追加
        penguinImageView.addGestureRecognizer(longGesture)
        
        
        //viewにImageViewを配置
        view.addSubview(penguinImageView)
        print("画像表示")
    }
    
    //画面をタッチした時に呼ばれる関数
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //一番初めにタッチしたものだけ取得。
        if let touch = touches.first{
            //タッチしたViewを取得
            let touchView = touch.view
            //タッチしたViewのタグがい「1」なら、そのViewの中心をタッチした位置に移動する。
            if touchView?.tag == 1{
                touchView?.frame.size.width = 150
                touchView?.frame.size.height = 150
                touchView?.center = touch.location(in: view)
            }
        }
    }
    
    //ドラッグ時に呼ばれる
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //画面タッチ時に呼ばれる関数と同じ処理を実行します。
        self.touchesBegan(touches, with: event)
    }
    
    //ドラッグ終了時に呼ばれる
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchView = touches.first?.view
        if touchView!.tag == 1{
            touchView!.frame.size.width = 100
            touchView!.frame.size.height = 100
        }
    }
    
    //長押しされた時に呼び出される。
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        sender.view!.removeFromSuperview()
    }
}

