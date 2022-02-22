/*
 * Bai9.c
 *         Viet chuong trình bam CT_1 dong chu “Hello-World” chay tung ky tu tu trai sang phai 
man hinh; bam CT_2 thi dong chu tren chay nguoc lai, bam CT_3 thi xoa man hinh. 
 * Created: 11/8/2021 12:28:08 PM
 * Author: nguyen thu thao
 */

#include <io.h>
#include <alcd.h> 
#include <delay.h>
#include <stdio.h>
#include <string.h>
#define BT1 PINB.2
#define BT2 PINB.3
#define BT3 PINB.0
char count=0,count1=0;
char data[12]="hello-world";
char temp[12]="";
char bam=0;
char size=11;
void copy(char data[], char temp[], char start, char end){
    char i=0;
    for (i = start ; i< end;i++){
        temp[i-start]=data[i];
    }
}
void main(void)
{
    DDRB = 0x00;
    PORTB =0x0D;
    lcd_init(16);

    while (1)
    {  
        delay_ms(50); 
        if (BT3==0){
            count1=0;
            count=0; 
            bam=0;
            lcd_clear(); 
        }
        if (BT1 ==0){
            bam=1;
            count1=0;
            count=0;
            memset(temp,0,sizeof temp);
            lcd_clear();
        }
        if (BT2 ==0){
            bam=2;
            count1=0;
            count=0; 
            memset(temp,0,sizeof temp);
            lcd_clear();
        }
        if (bam==1){
            if (count==size)
                continue;
            count1++;
            if (count1==16-count+1){
                count1=0;
                copy(data,temp,size-count-1,size);
                count++;
                continue;
            }
            lcd_clear();
            if (count>0){
                lcd_gotoxy(16-count,0); 
                lcd_puts(temp);
            }
            lcd_gotoxy(count1-1,0);     
            lcd_putchar(data[size-count-1]);
        }
        if (bam==2){
            if (count==size)
                continue;
            count1++;
            if (count1==16-count+1){
                count1=0;
                temp[count]=data[count];
                count++;
                continue;
            }
            lcd_clear();
            if (count>0){
                lcd_gotoxy(0,0); 
                lcd_puts(temp);
            }
            lcd_gotoxy(16-count1,0);     
            lcd_putchar(data[count]);
        }
    }
}
