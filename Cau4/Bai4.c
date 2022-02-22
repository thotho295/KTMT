/*
 * Bai4.c
 *   Viet chuong trinh dem su kien bam BT1 hien thi len den LED don 7 doan cac so tu 0 den 9 
 khi su kien > 9 thi reset ve 0, su dung loai A chung
 * Created: 11/7/2021 9:27:35 PM 
 * Author: nguyen thu thao  
 */

#include <io.h>
#include <delay.h>
#define BT1 PINB.2

void hienthi(int i){
        if (i == 0 ){
            PORTF = 0x80;
            PORTD = 0xF9;
            PORTA = 0x7F;
        } 
        if (i == 1 ){
            PORTF = 0x86;
            PORTD = 0xFF;
            PORTA = 0x7F;
        }  
        if (i == 2 ){
            PORTF = 0x84;
            PORTD = 0xF1;
            PORTA = 0xFF;
        }  
        if (i == 3 ){
            PORTF = 0x84;
            PORTD = 0xF5;
            PORTA = 0x7F;
        }  
        if (i == 4 ){
            PORTF = 0x82;
            PORTD = 0xF7;
            PORTA = 0x7F;
        }  
        if (i == 5 ){
            PORTF = 0xA0;
            PORTD = 0xF5;
            PORTA = 0x7F;
        }  
        if (i == 6 ){
            PORTF = 0b10100000 + 0b00000001;   
            PORTD = 0xF1; 
            PORTA = 0x7F;
        }  
        if (i == 7 ){
            PORTF = 0x84;
            PORTD = 0xFF;
            PORTA = 0x7F;
        }  
        if (i == 8 ){
            PORTF = 0x80;
            PORTD = 0xF1;
            PORTA = 0x7F;
        }  
        if (i == 9 ){
            PORTF = 0x80;
            PORTD = 0xF5;
            PORTA = 0x7F;
        }   
        
        delay_ms(250);
        PORTF = 0xA6;
        PORTD = 0xFF;
        PORTA = 0xFF;
}
void main(void){
    int count=0;
    DDRB = 0x00;
    DDRF = 0xFF;
    DDRD = 0xFF;
    DDRA = 0xFF;
    PORTB = 0x04;
    while (1)
        {
        if (BT1 == 0){
            count++;
        }
        count%=10;
        hienthi(count);  // E,F,G muon tac dong bit thi phai tac dong theo ca thanh ghi
        

        }
}
