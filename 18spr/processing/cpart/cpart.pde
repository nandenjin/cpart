/*

  # 使う前に、画面上端の「スケッチ」→「ライブラリをインポート」→「ライブラリを追加」で、
   「Websockets」っていう機能がインストールされてないといけない！注意
   
   

  再生すると、自動的にオンラインの中継サーバに接続します。
  誰かがボタンをクリックすると、その情報がClickクラスのデータとして配列clicksに保存されます。
  
  * 保存されているclickの個数 -> clicks.length
  * n番目のclickの名前 -> clicks[ n ].name
  * n番目のclickのアイテムの種類 -> clicks[ n ].kind
      - これ、今のところ整数（int）で入れています
        種類によって振った番号を使えばええんとちゃうかなぁ

*/


// 接続する機能のインポート
import websockets.*;

// 接続するやつ
WebsocketClient wsc;

// クリックの保存
Click[] clicks = {};

// 初期化
void setup(){
  
  // いつもの
  size(400,400);
  
  // 接続先を指定
  wsc= new WebsocketClient(this, "ws://ca.nandenjin.com");
  
}

// 描画
void draw() {
  
  
  // 色の設定
  background( 255 );
  fill( 0 );
  
  // 以下、とりあえず表示させるためのコード
  
  // 文字の描画位置
  int p = 30;
  
  // clicksに入っているのを「最後から最初へ」読み取っていく
  for( int i = clicks.length - 1; i >= 0; i-- ) {
    
    // それぞれのClickのnameとkindを文字として描画
    text( clicks[i].name + " " + clicks[i].kind, 0, p, 100, 15 );
    
    // 描画の位置をちょっと下へずらす
    p += 15;
    
  }
  
}


// クラス定義（クリック情報）
class Click{
  
  int kind = -1;
  String name = null;
  
}

// 以下、通信用の黒魔術

// データを受信すると呼び出される
void webSocketEvent(String msg){
  
  // とりあえず受信内容をコンソールに表示
  println(msg);
  
  // 受信内容の解析
  JSONObject json = parseJSONObject( msg );
  if( json == null ) return;
  
  // アイテムの種類を取得
  int kind = json.getInt( "kind", -1 );
  
  // 名前を取得
  String name = json.getString( "name" );
  
  println( kind, name );
  
  // どちらかが足りなかったらこれ以上続けない
  if( kind == -1 || name == null ) return;
  
  // Clickインスタンスを生成する
  Click click = new Click();
  click.kind = kind;
  click.name = name;
  
  // clicksに追加する
  clicks = (Click[])append( clicks, click );
  
}
