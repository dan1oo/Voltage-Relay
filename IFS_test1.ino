#define RELAY_1 2
#define RELAY_2 3
#define RELAY_3 4
#define RELAY_4 5
#define Switch 6

void setup() {
  Serial.begin(100);
  pinMode(RELAY_1, OUTPUT);
  pinMode(RELAY_2, OUTPUT);
  pinMode(RELAY_3, OUTPUT);
  pinMode(RELAY_4, OUTPUT);
  pinMode(Switch, INPUT);

  

}

void loop() {
  int switchState = digitalRead(Switch);
  Serial.println(switchState);
  if(switchState == 0){
    digitalWrite(RELAY_1, HIGH);
     
  }
  if(switchState == 1){
    digitalWrite(RELAY_1, LOW);
  }
  delay(100);
  
  

}
