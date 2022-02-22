/*
 * Bai3.c
 *      Viet c.t hien thi cac so tu 11,00 den 99,99 cac so sau dau , thay doi theo chu ky 0.1s
 * Created: 11/8/2021 9:50:14 AM
 * Author: nguyen thu thao
 */

#include <io.h>
#include <delay.h>

unsigned char LED4[10] = {0x3F,0x39,0x3B,0x3B,0x3D,0x1F,0x1D,0x3B,0x3F,0x3F}; 
unsigned char LED3[10] = {0x6F,0x69,0x6B,0x6B,0x6D,0x4F,0x4D,0x6B,0x6F,0x6F}; 
unsigned char LED2[10] = {0xF7,0xF1,0xF3,0xF3,0xF5,0xD7,0xD5,0xF3,0xF7,0xF7}; 
unsigned char LED1[10] = {0x7E,0x78,0x7A,0x7A,0x7C,0x5E,0x5C,0x7A,0x7E,0x7E};  
unsigned char LEDD[10] = {0x06,0x00,0x0E,0x0A,0x08,0x0A,0x0E,0x00,0x0E,0x0A}; 
unsigned char LEDA[10] = {0x80,0x80,0x00,0x80,0x80,0x80,0x80,0x80,0x80,0x80}; 
//unsigned char LEDF[10] = {0x26,0x20,0x22,0x22,0x24,0x06,0x04,0x22,0x26,0x26};
int count=0;
int r=1100;
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    TCNT0=0x06;        
    count++;

}
void hienthi(int x){
    int tmp,ch,dv,pch,ptr,i;
    tmp = x;
    ch = tmp/1000;
    dv = (tmp%1000)/100;
    pch = ((tmp%1000)%100)/10;
    ptr = ((tmp%1000)%100)%10;
    
    for(i=0;i<3;i++){
        //PORTF = 0b10100110;
        PORTF = LED1[ch]; 
        PORTD = LEDD[ch];
        PORTA = LEDA[ch];
        delay_us(10); 
        
        PORTF = LED2[dv];
        PORTD = LEDD[dv];
        PORTA = LEDA[dv];
        delay_us(10); 
        
        PORTF = LED3[pch];
        PORTD = LEDD[pch];
        PORTA = LEDA[pch];
        delay_us(10); 
        
        PORTF = LED4[ptr];
        PORTD = LEDD[ptr];
        PORTA = LEDA[ptr];
        delay_us(100); 
    }
}
void main(void){
    DDRF = 0xFF;
    DDRD = 0xFF;
    DDRA = 0xFF;
        ASSR=0<<AS0;
    TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
    TCNT0=0x06;
    OCR0=0x00;

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
    ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);


    // Global enable interrupts
    #asm("sei")
    while (1)
        {
            hienthi(r);
            if(count >= 100 && r<9999){
                r++;
                hienthi(r);
                count=0;
            }
        }
}
