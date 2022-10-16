

#include <SPFD5408_Adafruit_GFX.h>
#include <SPFD5408_Adafruit_TFTLCD.h>
#include <SPFD5408_TouchScreen.h>

#define LCD_CS  A3
#define LCD_CD  A2
#define LCD_WR  A1
#define LCD_RD  A0
#define LCD_RESET  A4

Adafruit_TFTLCD tft(LCD_CS, LCD_CD, LCD_WR, LCD_RD, LCD_RESET);
  int r = 50,i=0;
  uint64_t color = 0xFFFF,color1=0x191970;
  int x=115, y=100, r2 = 2 * r;
void setup()
{
  Serial.begin(9600);
  tft.reset();
  tft.begin();
 
 /* for (int rotation = 0; rotation < 4; rotation++)
  {
    tft.setRotation(rotation);
    for (x = 250; x <= r2; x += r2) {
      for (y = 250; y <= r2; y += r2) {
        tft.drawCircle(x, y, r, color);
         
        delay(2000);
      }
     
        }
      }
  }
  }*/
   
 

}
void loop()
{
tft.drawCircle(120, 100, 100, color);
tft.fillCircle(120, 100,100, color);
for(i=0;x<=100;x=x+20)
{
tft.drawCircle(x, y, r, color1);
tft.fillCircle(x, y, r, color1);
delay(500);
tft.fillCircle(x, y, r, color);

}
for(i=0;x>=100;x=x-20)
{
tft.drawCircle(x, y, r, color1);

tft.fillCircle(x, y, r, color1);
delay(500);
tft.fillCircle(x, y, r, color);

}

}
