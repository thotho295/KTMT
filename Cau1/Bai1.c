/*
 * Bai1.c
 * Viet ct nhap mk dang *** len man hinh LCD 
 neu nhap dung mk l? '8888' thi bat role 1, neu sai mk thi den do se nhap nhay canh bao
 man hinh yeu cau nhap lai mk, neu sai qua 3 lan th? bat role 2
 * Created: 11/8/2021 1:03:39 PM
 * Author: nguyen thu thao
 */

#include <io.h>
#include <delay.h>
#include <alcd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#define RL_1 PORTC.3 
#define RL_2 PORTC.2
#define LED PORTD.4
int keypad[3][3] ={1,2,3,4,5,6,7,8,9};
char count=0,count1=0,x=0,dem=0,dem1=0;
bool flag=0;
char temp[5]="";
char data[5]="";
char password[5]="8888";
char buffer[16]="";
void BUTTON(){
    char a;
    int i,j;
    for (j=0;j < 3 ; j++){
         if (j == 0) PORTF = 0xFD;//0b11111101
         if (j == 1) PORTF = 0xF7;//0b11110111
         if (j == 2) PORTF = 0xDF; //0b11011111 
         for(i = 0 ; i < 3 ; i++){
            if (i == 0){
                a = PINF.2;
                if(a == 0){
                    flag=1;   
                    lcd_gotoxy(count,0);       
                    data[count] = keypad[i][j]+'0';
                    lcd_putchar(data[count]);
                    count++;
                    delay_ms(500);
                }
            }
            if (i == 1){
                a = PINF.4;
                if(a == 0){   
                    flag=1;   
                    lcd_gotoxy(count,0);
                    data[count] = keypad[i][j]+'0';
                    lcd_putchar(data[count]);
                    count++;
                    delay_ms(500);
                }
            }
            if (i == 2){
                a = PINF.0;
                if(a == 0){
                    flag=1;     
                    lcd_gotoxy(count,0);
                    data[count] = keypad[i][j]+'0';
                    lcd_putchar(data[count]);  
                    count++;
                    delay_ms(500);
                }
            }
         }
    }
}
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    TCNT0=0x06; 
    if (x == 1){
        dem++;
        if (dem == 100) {
            LED=1-LED;
            dem=0;
            dem1++;            
        }
        if (dem1==5){
            dem=0;
            dem1=0;
            LED=0;
            x=0;
        }
    }
}

void main(void)
{
    lcd_init(16);
    DDRC = 0xFF;
    PORTC = 0x00;
    DDRF = 0xEA;//0b11101010;
    PORTF = 0x55;//0b00010101;
    DDRD=0x10;
    LED=0;
    ASSR= 0<<AS0;
    TCCR0 = 0x03;
    TCNT0 = 0x06;
    OCR0 = 0x00;
    TIMSK = 0x01;
    ETIMSK = 0x00;
    #asm("sei")
    while (1){ 
        BUTTON();
        lcd_clear(); 
        if (strcmp(data,"")){
            temp[count-1]='*';
            lcd_puts(temp);
            flag=0;
        }
        if (count ==4){ 
            if(!strcmp(data,password)){
                lcd_clear();
                RL_1=1;
                delay_ms(500);
                memset(temp, 0, sizeof temp);
                memset(data, 0, sizeof data);
                count=0;
            }       
            else    {

                count1++;
                x=1;
                if (count1==3) 
                    RL_2 = 1;
                lcd_clear();
                sprintf(buffer,"nhap lai mk");
                lcd_puts(buffer);  
                delay_ms(500);
                memset(temp, 0, sizeof temp);
                memset(data, 0, sizeof data);
                count=0;    
            }
                   
        }
        delay_ms(250);
    }
}
