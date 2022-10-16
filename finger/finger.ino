/* Sweep
  by BARRAGAN <http://barraganstudio.com>
  This example code is in the public domain.

  modified 28 May 2015
  by Michael C. Miller
  modified 8 Nov 2013
  by Scott Fitzgerald

  http://arduino.cc/en/Tutorial/Sweep
*/

#include <Servo.h>

Servo myservo0;
Servo myservo1;
Servo myservo2;
Servo myservo3;// create servo object to control a servo
// twelve servo objects can be created on most boards


void setup() 
{
  myservo0.attach(D0);
  myservo1.attach(D1);
  myservo2.attach(D2);
  myservo3.attach(D3);// attaches the servo on GIO2 to the servo object
}

void loop()
{
//  for(int i=0;i<90;i++)
//  {
//    myservo0.write(i);
//    myservo1.write(i);
//    myservo2.write(i);
//    myservo3.write(i);
//  }
//  delay(1000);
//  for(int i=90;i<180;i++)
//  {
//    myservo0.write(i);
//    myservo1.write(i);
//    myservo2.write(i);
//    myservo3.write(i);
//  }
//  delay(1000);
//  for(int i=180;i>90;i--)
//  {
//    myservo0.write(i);
//    myservo1.write(i);
//    myservo2.write(i);
//    myservo3.write(i);
//  }
//  delay(1000);
//  for(int i=90;i>0;i--)
//  {
//    myservo0.write(i);
//    myservo1.write(i);
//    myservo2.write(i);
//    myservo3.write(i);
//  }
//   delay(1000);
//    myservo0.detach();
//    myservo1.detach();
//    myservo2.detach();
//    myservo3.detach();

//myservo0.write(LOW);
//myservo1.write(LOW);
//myservo2.write(LOW);
//myservo3.write(LOW);
//delay(10000);
myservo1.write(0);
myservo2.write(0);
myservo3.write(0);
myservo0.write(0);
delay(1000);
myservo1.write(90);
myservo2.write(90);
myservo3.write(90);
myservo0.write(90);
delay(1000);
myservo1.write(180)
//myservo1.write(90);
//myservo2.write(90);
//myservo3.write(90);
//myservo0.write(90);
//delay(1000);
}
