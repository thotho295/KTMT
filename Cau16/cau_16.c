/*
 * cau_16.c
 *
 * Created: 12/19/2021 23:45:23
 * Author: gold_
 */

#include <io.h>
#include <delay.h>
#include <alcd.h>
#include <stdlib.h>

#define BT1     PINB.2
#define BT2     PINB.3
#define servo   PORTC.7
#define RC_MAX  166
#define RC_MIN  84


int count, RC;
char buffer[16];

interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
    TCNT0=0xB0;

    count++;
    if(count == 2000) {
        count = 0;
    }
    
    if(count < RC) {
        servo = 1;
    } else {
        servo = 0;
    }
}

void update_speed() {
    lcd_clear();
    itoa(RC, buffer);
    lcd_gotoxy(0, 0);
    lcd_putsf("RC:");
    lcd_gotoxy(3, 0);
    lcd_puts(buffer);        
}

void main(void) 
{
    DDRC = 0xFF;
    DDRB = 0x00;
    PORTB = 0xFF;   
    
    ASSR=0<<AS0;
    TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (1<<CS00);
    TCNT0=0xB0;
    OCR0=0x00;  
    
    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
    ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
    
    #asm("sei")
    
    RC = 125;
//    RC = 84;
//    RC = 166;

    lcd_init(16);
    
    update_speed();
        
    while(1) 
    {
        if(BT1 == 0) {
            delay_ms(200); 
            RC = RC_MAX;
            update_speed();  
            lcd_gotoxy(0, 1);
            lcd_putsf("Troi nang");
        }
        
        if(BT2 == 0) {
            delay_ms(200);
            RC = RC_MIN;
            update_speed();  
            lcd_gotoxy(0, 1);
            lcd_putsf("Troi mua");
        }
    }
}