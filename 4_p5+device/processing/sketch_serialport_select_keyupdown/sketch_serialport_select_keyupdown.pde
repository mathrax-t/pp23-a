import processing.serial.*;

Serial myPort;    // シリアル通信用の変数
color bgColor;    // 背景色の変数
String[] portNames; // 利用可能なシリアルポート名のリスト
int selectedPortIndex = -1; // -1 は未選択を表す
boolean dropdownOpen = true;  // 最初にプルダウンメニューを表示
boolean serialConnected = false; // シリアル通信が確立されたかどうか
float[] sensor = new float[3];  // センサーの値を格納する配列
int selectedMenuItem = 0;  // 選択中のメニュー項目

void setup() {
  size(800, 600);  // 画面サイズ

  // シリアルポートの一覧を取得
  portNames = Serial.list();
}

void draw() {
  background(bgColor);  // 背景色を設定
  updateBGColor();  // 背景色を更新
  drawUI();  // UIを描画
}

void updateBGColor() {
  // シリアル通信が確立され、かつポートが選択された場合に描画
  if (serialConnected && selectedPortIndex != -1) {
    bgColor = color(sensor[0], sensor[1], sensor[2]);
  }
}

void keyPressed() {
  // キーが押されたときに呼び出される
  if (key == ' ') {
    // スペースキーが押されたとき
    dropdownOpen = !dropdownOpen;
  } else if (key == ENTER) {
    // エンターキーが押されたとき
    if (dropdownOpen && !serialConnected) {
      checkPortSelection();
    }
  } else if (keyCode == UP) {
    // 上矢印キーが押されたとき
    selectedMenuItem = (selectedMenuItem - 1 + portNames.length) % portNames.length;
  } else if (keyCode == DOWN) {
    // 下矢印キーが押されたとき
    selectedMenuItem = (selectedMenuItem + 1) % portNames.length;
  }
}

void drawUI() {
  if (dropdownOpen && !serialConnected) {
    float dropdownWidth = width * 0.8;  // ドロップダウンメニューの幅
    float dropdownX = (width - dropdownWidth) / 2;  // ドロップダウンメニューのX座標

    // ドロップダウンメニューが開いている場合に描画
    for (int i = 0; i < portNames.length; i++) {
      fill(255);
      if (i == selectedMenuItem) {
        fill(200);
      }
      rect(dropdownX, 30 + i * 20, dropdownWidth, 20);
      fill(0);
      text(portNames[i], dropdownX + 5, 45 + i * 20);
    }
  } else if (selectedPortIndex != -1 && serialConnected) {
    // シリアル通信が確立され、かつポートが選択された場合に描画
    text("Serial Connected", 15, 25);
  }
}

void checkPortSelection() {
  selectedPortIndex = selectedMenuItem;  // 選択中のメニュー項目を確定

  openSerialPort();
  dropdownOpen = false; // ドロップダウンメニューを閉じる
}

void openSerialPort() {
  // 選択されたシリアルポートを開く
  String selectedPort = portNames[selectedPortIndex];
  if (myPort != null) {
    myPort.stop();  // すでにポートが開かれている場合は停止する
  }
  myPort = new Serial(this, selectedPort, 115200);
  myPort.bufferUntil('\n');  // 改行までのデータをバッファにためる
  serialConnected = true;
}

void serialEvent(Serial p) {
  String[] values = p.readStringUntil('\n').trim().split(",");
  
  if (values.length == 3) {
    sensor[0] = map(Float.parseFloat(values[0]), -1023, 1023, 0, 255);
    sensor[1] = map(Float.parseFloat(values[1]), -1023, 1023, 0, 255);
    sensor[2] = map(Float.parseFloat(values[2]), -1023, 1023, 0, 255);
  }
}
