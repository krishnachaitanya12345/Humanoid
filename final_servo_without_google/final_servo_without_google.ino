#include <Servo.h>

Servo servo1; 
Servo servo2;
Servo servo3;
Servo servo4;
Servo servo5;

int i = 0;

void setup() 
{
  servo1.attach(D0);
  servo2.attach(D1); 
  servo3.attach(D2); 
  servo4.attach(D3);
  servo5.attach(D4); 
  Serial.begin(115200);
}

void loop() 
{
  for (i = 0; i < 90; i++)
  { 
    servo1.write(i);              
    servo2.write(i);     
    servo3.write(i);
    servo4.write(i);
    servo5.write(i);         
    delay(10); 
    Serial.println(i);    
    Serial.println("front");                 
  }
    servo1.write(90);              
    servo2.write(90);     
    servo3.write(90);
    servo4.write(90);
    servo5.write(90);
    delay(1000);
  //servo1.detach();
  //servo1.attach(D0);
  for (i = 91; i < 181; i++) 
  { 
    servo1.write(i);                
    servo2.write(i);     
    servo3.write(i);
    servo4.write(i);          
    servo5.write(i);
    delay(10);  
    Serial.println(i);
    Serial.println("backward");                    
  }
//  delay(500);
//servo1.write(0);
//delay(5);
//servo1.write(90);
//delay(5);
//servo1.write(180);
//delay(5);
//servo1.write(90);
//delay(5);
//servo1.write(0);
//servo1.write(0);
//delay(0);
//servo1.write(90);
//delay(10);
//servo1.write(180);
//delay(10);
//servo1.write(90);
//delay(10);
//servo1.write(0);

}
