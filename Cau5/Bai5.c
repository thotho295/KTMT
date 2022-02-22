/*
 * Bai5.c
 *  Viet chuong trinh dem su kien bam BT1 hien thi len den LED don 7 doan cac so tu 0 den 9 
 khi su kien > 9 thi reset ve 0, su dung loai K chung
 * Created: 11/7/2021 9:42:46 PM 
 * Author: nguyen thu thao 
 */

#include <io.h> 
#include <delay.h> 
#define BT1 PINB.2
void hienThi(int i){ 
     if(i==0){ //abcdef
         PORTF = 0b10100110 + 0b00000001;  
         PORTD = 0x06; //1111 1001 0000 0110
         PORTA = 0x80;  //0111 1111 1000 0000
     } 
     if(i==1){ //bc
         PORTF = 0b10100000 + 0b00000001; 
         PORTD = 0x00;   //0b1111 1111
         PORTA = 0x80;   //0b1111 1111
     } 
     if(i==2){ //abged
         PORTF = 0b10100010 + 0b00000001; 
         PORTD = 0x0F;  //0b0000 1110
         PORTA = 0x00; 
     } 
     if(i==3){    //abgcd
         PORTF = 0b10100010 + 0b00000001; 
         PORTD = 0x0A; //0000 1010
         PORTA = 0x80; 
     } 
     if(i==4){ //fgbc
         PORTF = 0b10100100 + 0b00000001; 
         PORTD = 0x08; 
         PORTA = 0x80; 
     } 
     if(i==5){ //afgcd
         PORTF = 0b10000110 + 0b00000001; 
         PORTD = 0x0A; 
         PORTA = 0x80; 
     }     if(i==6){  //afgecd
         PORTF = 0b10000110 + 0b00000001;
         PORTD = 0x0F;  
         PORTA = 0x80; 
     } 
     if(i==7){ //abc
         PORTF = 0b10100010 + 0b00000001; 
         PORTD = 0x00; 
         PORTA = 0x80; 
     } 
     if(i==8){ //abcdefg
         PORTF = 0b10100110 + 0b00000001; 
         PORTD = 0x0F; 
         PORTA = 0x80; 
     } 
     if(i==9){ //abcdfg 
         PORTF = 0b10100110 + 0b00000001; 
         PORTD = 0x0A;  
         PORTA = 0x80; 
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
        hienThi(count);  // E,F,G muon tac dong bit thi phai tac dong theo ca thanh ghi
        

        }
}


