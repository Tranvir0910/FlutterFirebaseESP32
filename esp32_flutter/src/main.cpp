#include <Arduino.h>
#include <FirebaseESP32.h>
#include <WiFi.h>
#include <WiFiMulti.h>
#include <DHT.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>

WiFiMulti wifiMulti;

#define FIREBASE_HOST "greenhouse-16b3b-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "UKOpOrrgMQfJwbbm8Z13n2xbOSZcRg28tih0PP4I"

FirebaseData firebaseData;
FirebaseJson json;
FirebaseAuth auth;
FirebaseConfig config;

#define LIGHT_SENSOR_PIN A0 // ESP32 pin 4

#define DHTPIN 2    
#define DHTTYPE DHT11   
DHT dht(DHTPIN, DHTTYPE);

int moisture, sensor_analog; 
const int sensor_pin = 34;  /* Soil moisture sensor O/P pin */

float hum;
float temp;

LiquidCrystal_I2C lcd(0x27,20,4);
// SDA 21
// SCL 22

#define LED 18
#define MOTOR 19
#define FAN 5

String mainN = "";

int a, b, c, x, y, z, lightVal;

void setup() {

  wifiMulti.addAP("PTIT.HCM_SV", "");
  wifiMulti.addAP("PTIT.HCM_CanBo", "");
  wifiMulti.addAP("ThaiBao", "0869334749");


  pinMode(LED, OUTPUT );
  pinMode(MOTOR, OUTPUT);
  pinMode(FAN, OUTPUT);

  Serial.begin(115200);
  // Set up DHT11
  dht.begin();

  // Set up LCD_I2C
  lcd.init();
  lcd.backlight();

  Serial.print("Connecting...");
  while (wifiMulti.run() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());
  Serial.println();
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.reconnectWiFi(true);

  Firebase.setReadTimeout(firebaseData, 1000*60);
  Firebase.setwriteSizeLimit(firebaseData, "tiny");    


  config.api_key = FIREBASE_AUTH;
  config.database_url = FIREBASE_HOST;                 
}

void loop() {

  x = digitalRead(LED);
  y = digitalRead(MOTOR);
  z = digitalRead(FAN);
  int analogValue = analogRead(LIGHT_SENSOR_PIN); 


  if(Firebase.ready()){
    
    Serial.printf("status led: %s\n", Firebase.getInt(firebaseData, "/FirebaseIOT/status led") 
      ? String(firebaseData.to<int>()).c_str() 
      : firebaseData.errorReason().c_str());
    a = firebaseData.to<int>();
    Serial.printf("status motor: %s\n", Firebase.getInt(firebaseData, "/FirebaseIOT/status motor") 
      ? String(firebaseData.to<int>()).c_str() 
      : firebaseData.errorReason().c_str());
    b = firebaseData.to<int>();
    Serial.printf("status fan: %s\n", Firebase.getInt(firebaseData, "/FirebaseIOT/status fan") 
      ? String(firebaseData.to<int>()).c_str() 
      : firebaseData.errorReason().c_str());
    c = firebaseData.to<int>();
    
    Serial.println();
    Serial.println("------------------");
    Serial.println();

    if( a == 1 ){
      digitalWrite(LED, HIGH);
    }else{
      digitalWrite(LED, LOW);
    }
    if( b == 1){
      digitalWrite(MOTOR, HIGH);
    }else{
      digitalWrite(MOTOR, LOW);
    }
    if( c == 1){
      digitalWrite(FAN, HIGH);
    }else{
      digitalWrite(FAN, LOW);
    }
  }
  
  if(analogValue > 1000){
    digitalWrite(LED, HIGH);
  }
  
  Serial.printf("light sensor ( Analog )  %s\n", Firebase.getInt(firebaseData, "/FirebaseIOT/light sensor ( Analog )") ? String(firebaseData.to<int>()).c_str() : firebaseData.errorReason().c_str());
  lightVal = firebaseData.to<int>();


  sensor_analog = analogRead(sensor_pin);
  moisture = ( 100 - ( (sensor_analog/4095.00) * 100 ) );
  Serial.print("Moisture = ");
  Serial.print(moisture);  /* Print Temperature on the serial window */
  Serial.println("%"); 

  hum = dht.readHumidity();
  temp = dht.readTemperature();  

  if (isnan(hum) || isnan(temp)  ){
    Serial.println(F("Failed to read from DHT sensor!"));
    return;
  }else{
    lcd.setCursor(0,0);
    lcd.print("T/H:");
    lcd.print(temp);
    lcd.print("/");
    lcd.print(hum);

    lcd.setCursor(0,1);
    lcd.print("DoAmDat:");
    lcd.print(moisture);
    lcd.print("%");
  }

  Serial.print("Temperature: ");
  Serial.print(temp);
  Serial.print("°C");
  Serial.print(" Humidity: ");
  Serial.print(hum);
  Serial.print("%");
  Serial.println();
  Serial.println("----------------------------------------");

  Firebase.setFloat(firebaseData, "/FirebaseIOT/temperature", temp);
  Firebase.setFloat(firebaseData, "/FirebaseIOT/humidity", hum);
  Firebase.setFloat(firebaseData, "/FirebaseIOT/moisture", moisture);
  Firebase.setFloat(firebaseData, "/FirebaseIOT/light sensor ( Analog )", analogValue);
  // Firebase.setString(firebaseData, "/FirebaseIOT/light", lightValue);

}


