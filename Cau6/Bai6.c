/*
 * Bai6.c
 *   Viet chuong trinh hien thi LED don 7 doan, hien thi cac so tu 0 den 9 tren A chung 
 * Created: 11/07/2021 9:52:58 AM
 * Author: nguyen thu thao  
 */

#include <io.h>
#include <delay.h>
#define BT1 PINB.2

 void hienthi(){
/// A-D binh thuong
///E,F,G muon tac dong bit, ta phai tac dong ca thanh ghi

    int i; 
     for(i = 0; i <= 9 ; i++){ 
         if(i==0){ 
            PORTF = 0b10000000 + 0b00000001; 
             PORTD = 0xF9;  // 1111 1001
             PORTA = 0x7F;  // 0111 1111 
         } 
         if(i==1){ 
            PORTF = 0b10000110 + 0b00000001; 
            PORTD = 0xFF;     //1111 1111
            PORTA = 0x7F;     //0111 1111
         } 
         if(i==2){ 
             PORTF = 0b10000100 + 0b00000001; 
             PORTD = 0xF1; 
             PORTA = 0xFF; 
         } 
         if(i==3){ 
            PORTF = 0b10000100 + 0b00000001; 
             PORTD = 0xF5; 
             PORTA = 0x7F; 
         } 
         if(i==4){ 
            PORTF = 0b10000010 + 0b00000001; 
             PORTD = 0xF7; 
             PORTA = 0x7F; 
         } 
         if(i==5){
            PORTF = 0b10100000 + 0b00000001; 
             PORTD = 0xF5; 
             PORTA = 0x7F; 
         } 
         if(i==6){ 
             PORTF = 0b10100000 + 0b00000001;   
             PORTD = 0xF1; 
             PORTA = 0x7F; 
         } 
         if(i==7){ 
             PORTF = 0b10000100 + 0b00000001; 
             PORTD = 0xFF; 
             PORTA = 0x7F; 
         } 
         if(i==8){ 
             PORTF = 0b10000000 +0b00000001; 
             PORTD = 0xF1; 
             PORTA = 0x7F; 
         } 
         if(i==9){ 
             PORTF = 0b10000000 + 0b00000001; 
             PORTD = 0xF5; 
             PORTA = 0x7F; 
         } 
         delay_ms(500); 
         PORTF = 0xA6; 
         PORTD = 0xFF; 
         PORTA = 0xFF; 
     }     
     
}    
void main(void){

    DDRB = 0x00;
    DDRF = 0xFF;
    DDRD = 0xFF;
    DDRA = 0xFF;
    PORTB = 0x04;
    while (1){
        hienthi();  // E,F,G muon tac dong bit thi phai tac dong theo ca thanh ghi

    }
}
