/*
 * Bai8.c
 *
 * Created: 11/11/2021 8:58:21 AM
 * Author: nguyen thu thao
 */

#include <io.h>
#include <delay.h>
#include <alcd.h>
#include <stdio.h>
#define BT1 PINB.3
#define BT2 PINB.2
#define LED PORTD.4
int dem;
char buffer[10];
void main(void)
{
DDRB = 0x00;
PORTB = 0x0C;
DDRD = 0x10;
PORTD = 0x00;
DDRC=0xFF;
PORTC=0x00;    //0b0000 0000
lcd_init(16);
sprintf(buffer,"so nguoi: %d", dem);
lcd_clear();
lcd_puts(buffer);
while (1)
    {
    if(BT2 == 0 ){
        while (BT1);
        delay_ms(250);
        dem--;
        if (dem <0 ) dem=0;
        sprintf(buffer,"so nguoi:%d", dem);
        lcd_clear();
        lcd_puts(buffer);
    }
    if (BT1 == 0){
        while(BT2);
        delay_ms(250);
        dem++;
        sprintf(buffer,"so nguoi:%d", dem);
        lcd_clear();
        lcd_puts(buffer);
    }
    if (dem > 0) {
        LED = 1;
        PORTC = 0b00001000;
        if (dem >5 ){
            PORTC = 0x0C; //0b00001100
        }
        else  {
            PORTC = 0x08; //0b00001000
        }
    }
    else {
        LED =0;
        PORTC = 0x00;
    }
    }
}
