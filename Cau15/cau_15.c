/*
 * cau_15.c
 *
 * Created: 1/14/2022 14:05:14
 * Author: gold_
 */

#include <io.h>
#include <delay.h>
#include <alcd.h>
#include <stdlib.h>
#include <stdio.h>

#define BT1     PINB.1
#define DIR     PORTD.7
#define SPEED   OCR0

char buffer[16];
int speed_value;

void update_lcd() {
    speed_value = 255 - SPEED;   
    lcd_gotoxy(0, 0); 
    sprintf(buffer,"SPEED:%03d",speed_value);
    lcd_puts(buffer);   
    delay_ms(5);
}

void main(void)
{
    DDRB = 0x10;
    PORTB = 0x0E;
    DDRD = 0x80;       
    
    ASSR=0<<AS0;
    TCCR0=(1<<WGM00) | (1<<COM01) | (1<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
    TCNT0=0x00;
    OCR0=0xFF;   
    
    lcd_init(16);
    delay_ms(20);
while (1)
    {         
        if(BT1 == 0) {
            if(SPEED == 0) {
                SPEED = 0;
            } else {
                SPEED = SPEED - 5;
            }
            update_lcd(); 
        } else {
            if(SPEED == 255) {
                SPEED = 255;
            } else {
                SPEED = SPEED + 5;
            }
            delay_ms(5);
            update_lcd();
        }
    }
}
