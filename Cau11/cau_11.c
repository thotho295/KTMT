/*
 * cau_11.c
 *
 * Created: 11/5/2021 10:52:15
 * Author: gold_
 */

#include <io.h>
#include <delay.h>
#include <alcd.h>


#define BT      PINB.2
#define RED     PORTD.4
#define GREEN   PORTD.5
#define BLUE    PORTD.6

int count = 0;
int dem, j= 0;


interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{

    TCNT0=0x9C;   
    
    if(j <= 5) {
        dem++;
        lcd_gotoxy(j,0);
        lcd_putsf("hello-world");    
        if(dem >= 100) {
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
    DDRB = 0x00;
    PORTB = 0x04;
    DDRD = 0x70;     
    
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
        
        if(BT == 0) {
            delay_ms(40);
            count++; 
        }
        if(count == 1) {
            RED = 1;
            GREEN = 0;
            BLUE = 0;        
        } else if (count == 2) {
            RED = 0;
            GREEN = 1;
            BLUE = 0;
        } else if (count == 3) {
            RED = 0;
            GREEN = 0;
            BLUE = 1;
        }
        if (count > 3) {
            count = 1;
        }        

    }       
}
