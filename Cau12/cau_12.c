/*
 * cau_12.c
 *
 * Created: 11/5/2021 13:29:20
 * Author: gold_
 */

#include <io.h>
#include <delay.h> // goi thu vien lien quan cac ham lam tre thoi gian
#include <alcd.h>

#define LED     PORTD.5
#define BT1     PINB.2
#define BT2     PINB.3
#define BT3     PINB.4

int i;
int dem, j= 0;

interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    TCNT0=0x9C;   
    
    if(j <= 5) {
        dem++;
        lcd_gotoxy(j,0);
        lcd_putsf("hello-world");    
        if(dem >= 80) {
            dem = 0;
            lcd_clear();
            j++;
        }  
    }
    if(j > 5) {
        j = 0;
    } 
}

void main(void)
{
    DDRD = 0x20;
    PORTD = 0x00;
    DDRB = 0x00;
    PORTB = 0x1C;
    
    ASSR=0<<AS0;
    TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (1<<CS01) | (0<<CS00);
    TCNT0=0x9C;
    OCR0=0x00;
    
    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
    ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);

    lcd_init(16);
    lcd_gotoxy(0, 0); 
    lcd_putsf("hello-world");
    
    #asm("sei")
    
    while (1)
    {
        if(BT1 == 0) {
            delay_ms(40);
            LED = 1;
        }
        
        if(BT2 == 0) {
            delay_ms(40);
            LED = 0;
        }           
        
        if(BT3 == 0) {
            delay_ms(40);
            for(i = 0; i < 2; i++) {
                LED = 1;
                delay_ms(40);
                LED = 0;
                delay_ms(40);
            }
            LED = 1;
        }
    }
}
