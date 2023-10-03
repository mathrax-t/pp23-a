//フォロワーのプログラム

#include <M5Core2.h>
// #include <M5Stack.h>
#include <esp_now.h>
#include <WiFi.h>

//リーダー数
#define LEADER_NUM 2

//リーダーのMACアドレス
int MAC[LEADER_NUM][6] = {
  { 0x08, 0xB6, 0x1F, 0x88, 0x1F, 0xDC }, // 1台目のMACアドレス
  { 0xD4, 0xD4, 0xDA, 0x85, 0x56, 0x6C }, // 2台目のMACアドレス
  // { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
  // { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
};

//無線のチャンネル
//フォロワーとリーダーを同じチャンネルにする
//WiFi2.4GHz範囲 1~13
#define CHANNEL 1

//アクセスポイント名
//上記のチャンネルを変えれば、SSIDは変えなくてよい
const char *SSID = "Follower_1";

// 加速度XYZ ＊ リーダー数の配列を準備
int myData[3 * LEADER_NUM];


// Init ESP Now with fallback
void InitESPNow() {
  WiFi.disconnect();
  if (esp_now_init() == ESP_OK) {
    Serial.println("ESPNow Init Success");
  } else {
    Serial.println("ESPNow Init Failed");
    ESP.restart();
  }
}

// config AP SSID
void configDeviceAP() {
  // const char *SSID = "Follower_1";
  bool result = WiFi.softAP(SSID, "Follower_1_Password", CHANNEL, 0);
  if (!result) {
    Serial.println("AP Config failed.");
  } else {
    Serial.println("AP Config Success. Broadcasting with AP: " + String(SSID));
    Serial.print("AP CHANNEL ");
    Serial.println(WiFi.channel());
  }
}

void setup() {
  M5.begin();
  M5.Lcd.setTextSize(2);

  for (int i = 0; i < sizeof(myData) / sizeof(int); i++) {
    myData[i] = 0;
  }
  Serial.begin(9600);
  Serial.println("ESPNow/Basic/Follower Example");
  //Set device in AP mode to begin with
  WiFi.mode(WIFI_AP);
  // configure device AP mode
  configDeviceAP();
  // This is the mac address of the Follower in AP Mode
  M5.Lcd.print("AP MAC: ");
  M5.Lcd.println(WiFi.softAPmacAddress());
  // Init ESPNow with a fallback logic
  InitESPNow();
  // Once ESPNow is successfully Init, we will register for recv CB to
  // get recv packer info.
  esp_now_register_recv_cb(OnDataRecv);
  delay(500);
  M5.Lcd.fillScreen(BLACK);
  M5.Lcd.setTextColor(WHITE, BLACK);
}

// callback when data is recv from Master
void OnDataRecv(const uint8_t *mac_addr, const uint8_t *data, int data_len) {
  char macStr[18];
  snprintf(macStr, sizeof(macStr), "%02x:%02x:%02x:%02x:%02x:%02x",
           mac_addr[0], mac_addr[1], mac_addr[2], mac_addr[3], mac_addr[4], mac_addr[5]);

  for (int i = 0; i < LEADER_NUM; i++) {
    int mac_match = 0;
    for (int j = 0; j < 6; j++) {
      //MACアドレスと一致するか
      if (mac_addr[j] == MAC[i][j]) {
        mac_match++;
      }
    }
    if (mac_match == 6) {
      //myData配列に、受信データを入れる
      myData[0 + i * 3] = *data;        //x
      myData[1 + i * 3] = *(data + 1);  //y
      myData[2 + i * 3] = *(data + 2);  //z
    }
  }
}

void loop() {
  //デバイス情報を表示
  M5.Lcd.setTextColor(ORANGE, BLACK);
  M5.Lcd.setCursor(5, 5);
  M5.Lcd.print("FOLLOWER");
  M5.Lcd.setTextColor(WHITE, BLACK);
  M5.Lcd.setCursor(5, 25);
  M5.Lcd.print("MAC: ");
  M5.Lcd.println(WiFi.macAddress());
  M5.Lcd.setCursor(5, 45);
  M5.Lcd.print("CHANNEL: ");
  M5.Lcd.println(WiFi.channel());

  //リーダーのデータ表示
  for (int i = 0; i < LEADER_NUM; i++) {
    draw_Leader(i);
  }

  //受信した加速度のデータを、PCに送る
  //（0~255の値を、-1.0~1.0にしてPCへ送っています。他のプログラムサンプルと合わせるため）
  for (int i = 0; i < 3 * LEADER_NUM; i++) {
    float sendData = (float(myData[i]) / 255.0) * 2.0 - 1.0;
    Serial.print(sendData);
    Serial.print(",");
  }
  //改行を送る
  Serial.println();

  //少しまつ
  // delay(10);
}


//リーダーの表示
void draw_Leader(int id) {
  //加速度センサ X軸
  int ax = map(myData[0 + id * 3], 0, 255, 0, 155);
  int ay = map(myData[1 + id * 3], 0, 255, 0, 155);
  int az = map(myData[2 + id * 3], 0, 255, 0, 155);
  switch (id) {
    case 0:
      M5.Lcd.setCursor(5, 75);
      M5.Lcd.print("LEADER 1");
      M5.Lcd.fillRect(ax, 95, 155 - ax, 5, DARKGREY);  //灰色の四角
      M5.Lcd.fillRect(0, 95, ax, 5, RED);              //赤い四角

      M5.Lcd.fillRect(ay, 105, 155 - ay, 5, DARKGREY);  //灰色の四角
      M5.Lcd.fillRect(0, 105, ay, 5, GREEN);            //緑の四角

      M5.Lcd.fillRect(az, 115, 155 - az, 5, DARKGREY);  //灰色の四角
      M5.Lcd.fillRect(0, 115, az, 5, CYAN);             //水色の四角
      break;

    case 1:
      M5.Lcd.setCursor(165, 75);
      M5.Lcd.print("LEADER 2");
      M5.Lcd.fillRect(160 + ax, 95, 315 - ax, 5, DARKGREY);  //灰色の四角
      M5.Lcd.fillRect(160, 95, ax, 5, RED);                  //赤い四角

      M5.Lcd.fillRect(160 + ay, 105, 315 - ay, 5, DARKGREY);  //灰色の四角
      M5.Lcd.fillRect(160, 105, ay, 5, GREEN);                //緑の四角

      M5.Lcd.fillRect(160 + az, 115, 315 - az, 5, DARKGREY);  //灰色の四角
      M5.Lcd.fillRect(160, 115, az, 5, CYAN);                 //水色の四角
      break;

    case 2:
      M5.Lcd.setCursor(5, 145);
      M5.Lcd.print("LEADER 3");
      M5.Lcd.fillRect(ax, 165, 155 - ax, 5, DARKGREY);  //灰色の四角
      M5.Lcd.fillRect(0, 165, ax, 5, RED);              //赤い四角

      M5.Lcd.fillRect(ay, 175, 155 - ay, 5, DARKGREY);  //灰色の四角
      M5.Lcd.fillRect(0, 175, ay, 5, GREEN);            //緑の四角

      M5.Lcd.fillRect(az, 185, 155 - az, 5, DARKGREY);  //灰色の四角
      M5.Lcd.fillRect(0, 185, az, 5, CYAN);             //水色の四角
      break;

    case 3:
      M5.Lcd.setCursor(165, 145);
      M5.Lcd.print("LEADER 4");
      M5.Lcd.fillRect(160 + ax, 165, 315 - ax, 5, DARKGREY);  //灰色の四角
      M5.Lcd.fillRect(160, 165, ax, 5, RED);                  //赤い四角

      M5.Lcd.fillRect(160 + ay, 175, 315 - ay, 5, DARKGREY);  //灰色の四角
      M5.Lcd.fillRect(160, 175, ay, 5, GREEN);                //緑の四角

      M5.Lcd.fillRect(160 + az, 185, 315 - az, 5, DARKGREY);  //灰色の四角
      M5.Lcd.fillRect(160, 185, az, 5, CYAN);                 //水色の四角
      break;
  }
}
