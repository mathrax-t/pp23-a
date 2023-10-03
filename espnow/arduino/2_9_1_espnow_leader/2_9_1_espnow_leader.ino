//リーダーのプログラム

#include <M5Core2.h>
#include <esp_now.h>
#include <WiFi.h>
#include <esp_wifi.h>

//フォロワーを管理する変数
esp_now_peer_info_t follower;

//無線のチャンネル
//フォロワーとリーダーを同じチャンネルにする
//WiFi2.4GHz範囲 1~13
#define CHANNEL 1


//加速度センサ
float accX = 0;
float accY = 0;
float accZ = 0;

#define PRINTSCANRESULTS 0
#define DELETEBEFOREPAIR 0

// Init ESP Now with fallback
void InitESPNow() {
  WiFi.disconnect();
  if (esp_now_init() == ESP_OK) {
    Serial.println("ESPNow Init Success");
  } else {
    Serial.println("ESPNow Init Failed");
    // Simply Restart
    ESP.restart();
  }
}

// Scan for followers in AP mode
void ScanForFollower() {
  int16_t scanResults = WiFi.scanNetworks(false, false, false, 300, CHANNEL);  // Scan only on one channel
  // reset on each scan
  bool followerFound = 0;
  memset(&follower, 0, sizeof(follower));

  Serial.println("");
  if (scanResults == 0) {
    Serial.println("No WiFi devices in AP Mode found");
  } else {
    Serial.print("Found ");
    Serial.print(scanResults);
    Serial.println(" devices ");
    for (int i = 0; i < scanResults; ++i) {
      // Print SSID and RSSI for each device found
      String SSID = WiFi.SSID(i);
      int32_t RSSI = WiFi.RSSI(i);
      String BSSIDstr = WiFi.BSSIDstr(i);

      if (PRINTSCANRESULTS) {
        Serial.print(i + 1);
        Serial.print(": ");
        Serial.print(SSID);
        Serial.print(" (");
        Serial.print(RSSI);
        Serial.print(")");
        Serial.println("");
      }
      delay(10);
      // Check if the current device starts with `Follower`
      if (SSID.indexOf("Follower") == 0) {
        // SSID of interest
        Serial.println("Found a follower.");
        Serial.print(i + 1);
        Serial.print(": ");
        Serial.print(SSID);
        Serial.print(" [");
        Serial.print(BSSIDstr);
        Serial.print("]");
        Serial.print(" (");
        Serial.print(RSSI);
        Serial.print(")");
        Serial.println("");
        // Get BSSID => Mac Address of the follower
        int mac[6];
        if (6 == sscanf(BSSIDstr.c_str(), "%x:%x:%x:%x:%x:%x", &mac[0], &mac[1], &mac[2], &mac[3], &mac[4], &mac[5])) {
          for (int ii = 0; ii < 6; ++ii) {
            follower.peer_addr[ii] = (uint8_t)mac[ii];
          }
        }
        follower.channel = CHANNEL;  // pick a channel
        follower.encrypt = 0;        // no encryption

        followerFound = 1;
        // we are planning to have only one follower in this example;
        // Hence, break after we find one, to be a bit efficient
        break;
      }
    }
  }

  if (followerFound) {
    Serial.println("follower Found, processing..");
  } else {
    Serial.println("follower Not Found, trying again.");
  }

  // clean up ram
  WiFi.scanDelete();
}

// Check if the follower is already paired with the master.
// If not, pair the follower with master
bool manageFollower() {
  if (follower.channel == CHANNEL) {
    if (DELETEBEFOREPAIR) {
      deletePeer();
    }

    Serial.print("follower Status: ");
    // check if the peer exists
    bool exists = esp_now_is_peer_exist(follower.peer_addr);
    if (exists) {
      // follower already paired.
      Serial.println("Already Paired");
      return true;
    } else {
      // follower not paired, attempt pair
      esp_err_t addStatus = esp_now_add_peer(&follower);
      if (addStatus == ESP_OK) {
        // Pair success
        Serial.println("Pair success");
        return true;
      } else if (addStatus == ESP_ERR_ESPNOW_NOT_INIT) {
        // How did we get so far!!
        Serial.println("ESPNOW Not Init");
        return false;
      } else if (addStatus == ESP_ERR_ESPNOW_ARG) {
        Serial.println("Invalid Argument");
        return false;
      } else if (addStatus == ESP_ERR_ESPNOW_FULL) {
        Serial.println("Peer list full");
        return false;
      } else if (addStatus == ESP_ERR_ESPNOW_NO_MEM) {
        Serial.println("Out of memory");
        return false;
      } else if (addStatus == ESP_ERR_ESPNOW_EXIST) {
        Serial.println("Peer Exists");
        return true;
      } else {
        Serial.println("Not sure what happened");
        return false;
      }
    }
  } else {
    // No follower found to process
    Serial.println("No follower found to process");
    return false;
  }
}

void deletePeer() {
  esp_err_t delStatus = esp_now_del_peer(follower.peer_addr);
  Serial.print("follower Delete Status: ");
  if (delStatus == ESP_OK) {
    // Delete success
    Serial.println("Success");
  } else if (delStatus == ESP_ERR_ESPNOW_NOT_INIT) {
    // How did we get so far!!
    Serial.println("ESPNOW Not Init");
  } else if (delStatus == ESP_ERR_ESPNOW_ARG) {
    Serial.println("Invalid Argument");
  } else if (delStatus == ESP_ERR_ESPNOW_NOT_FOUND) {
    Serial.println("Peer not found.");
  } else {
    Serial.println("Not sure what happened");
  }
}


uint8_t sensor_data[3];
// send data
void sendData() {
  const uint8_t *peer_addr = follower.peer_addr;

  esp_err_t result = esp_now_send(peer_addr, &sensor_data[0], sizeof(sensor_data));

  if (result == ESP_OK) {
    Serial.println("Success");
  } else if (result == ESP_ERR_ESPNOW_NOT_INIT) {
    // How did we get so far!!
    Serial.println("ESPNOW not Init.");
  } else if (result == ESP_ERR_ESPNOW_ARG) {
    Serial.println("Invalid Argument");
  } else if (result == ESP_ERR_ESPNOW_INTERNAL) {
    Serial.println("Internal Error");
  } else if (result == ESP_ERR_ESPNOW_NO_MEM) {
    Serial.println("ESP_ERR_ESPNOW_NO_MEM");
  } else if (result == ESP_ERR_ESPNOW_NOT_FOUND) {
    Serial.println("Peer not found.");
  } else {
    Serial.println("Not sure what happened");
  }
}

// callback when data is sent from Master to follower
void OnDataSent(const uint8_t *mac_addr, esp_now_send_status_t status) {
  char macStr[18];
  snprintf(macStr, sizeof(macStr), "%02x:%02x:%02x:%02x:%02x:%02x",
           mac_addr[0], mac_addr[1], mac_addr[2], mac_addr[3], mac_addr[4], mac_addr[5]);
  // Serial.print("Last Packet Sent to: "); Serial.println(macStr);
  // Serial.print("Last Packet Send Status: "); Serial.println(status == ESP_NOW_SEND_SUCCESS ? "Delivery Success" : "Delivery Fail");
}

void setup() {

  M5.begin();
  M5.IMU.Init();
  M5.Lcd.setTextSize(2);

  Serial.begin(9600);
  //Set device in STA mode to begin with
  WiFi.mode(WIFI_STA);
  esp_wifi_set_channel(CHANNEL, WIFI_SECOND_CHAN_NONE);
  Serial.println("ESPNow/Basic/Master Example");
  // This is the mac address of the Master in Station Mode
  M5.Lcd.print("STA MAC: ");
  M5.Lcd.println(WiFi.macAddress());
  M5.Lcd.print("STA CHANNEL ");
  M5.Lcd.println(WiFi.channel());
  // Init ESPNow with a fallback logic
  InitESPNow();
  // Once ESPNow is successfully Init, we will register for Send CB to
  // get the status of Trasnmitted packet
  esp_now_register_send_cb(OnDataSent);

  delay(500);

  M5.Lcd.fillScreen(BLACK);
  M5.Lcd.setTextColor(WHITE, BLACK);

  //最初に受信デバイスを探します
  ScanForFollower();
}

void loop() {
  //デバイス情報を表示
  M5.Lcd.setTextColor(MAGENTA, BLACK);
  M5.Lcd.setCursor(5, 5);
  M5.Lcd.print("LEADER");
  M5.Lcd.setTextColor(WHITE, BLACK);
  M5.Lcd.setCursor(5, 25);
  M5.Lcd.print("MAC: ");
  M5.Lcd.println(WiFi.macAddress());
  M5.Lcd.setCursor(5, 45);
  M5.Lcd.print("CHANNEL: ");
  M5.Lcd.println(WiFi.channel());

  //センサ情報を変数にいれる
  M5.IMU.getAccelData(&accX, &accY, &accZ);
  //加速度センサ X軸
  M5.Lcd.setCursor(5, 75);
  M5.Lcd.print("accX");
  sensor_data[0] = constrain(map(accX * 100, -100, 100, 0, 255), 0, 255);
  M5.Lcd.setCursor(80, 75);
  M5.Lcd.printf("%3d",sensor_data[0]);
  //センサ情報を幅として四角を描く
  int ax = map(accX*100, -100, 100, 0, 320);
  M5.Lcd.fillRect(ax, 95, 320 - ax, 5, DARKGREY); //灰色の四角
  M5.Lcd.fillRect(0, 95, ax, 5, RED);  //赤い四角

  //加速度センサ Y軸
  M5.Lcd.setCursor(5, 135);
  M5.Lcd.print("accY");
  sensor_data[1] = constrain(map(accY * 100, -100, 100, 0, 255), 0, 255);
  M5.Lcd.setCursor(80, 135);
  M5.Lcd.printf("%3d",sensor_data[1]);
  int ay = map(accY*100, -100, 100, 0, 320);
  M5.Lcd.fillRect(ay, 155, 320 - ay, 5, DARKGREY); //灰色の四角
  M5.Lcd.fillRect(0, 155, ay, 5, GREEN); //緑の四角

  //加速度センサ Z軸
  M5.Lcd.setCursor(5, 195);
  M5.Lcd.print("accZ");
  sensor_data[2] = constrain(map(accZ * 100, -100, 100, 0, 255), 0, 255);
  M5.Lcd.setCursor(80, 195);
  M5.Lcd.printf("%3d",sensor_data[2]);
  int az = map(accZ*100, -100, 100, 0, 320);
  M5.Lcd.fillRect(az, 215, 320 - az, 5, DARKGREY); //灰色の四角
  M5.Lcd.fillRect(0, 215, az, 5, CYAN); //水色の四角

  if (follower.channel == CHANNEL) {  // check if follower channel is defined
    bool isPaired = manageFollower();
    if (isPaired) {
      sendData();
    } else {
      Serial.println("follower pair failed!");
    }
  } else {
    // No follower found to process
  }
  // wait for 0.01seconds to run the logic again
  delay(10);
}
