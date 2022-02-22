/*
 * Bai10.c
 *   Viet chuong tr�nh bam CT_1 dong chu �Hello-World� chay tu trai sang phai 
man hinh; bam CT_2 thi dong chu tren chay nguoc lai, bam CT_3 thi xoa man hinh. 
 * Created: 11/7/2021 10:10:59 PM
 * Author: nguyen thu thao 
 */

#include <io.h>
#include <alcd.h> 
#include <delay.h>

#define BT1 PINB.2
#define BT2 PINB.3
#define BT3 PINB.0
char count=0;
char bam=0;
void main(void)
{
DDRB = 0x00;
PORTB =0x0D;
lcd_init(16);

while (1)
    {  
        delay_ms(100); 
        if (BT3==0){
            count=0; 
            bam=0;
            lcd_clear(); 
        }
         if (BT1 == 0){
            bam=1;
            count=0;
            lcd_clear();
        }
        if (BT2 == 0){
            bam=2; 
            count=0;    
            lcd_clear();
        }
        if (bam==1){
//            bam=1;
            count++;
            count%=7;
            if (count==0){
                bam = 0;
                continue;
            } 
            lcd_clear();
            lcd_gotoxy(count-1,0);
            lcd_putsf("hello-world"); 
        }
        if (bam==2){
            count++;
            count%=7; 
            if (count==0){
                bam = 0;
                continue;
            } 
            lcd_clear();
            lcd_gotoxy(6-count,0);
            lcd_putsf("hello-world");  
        }
    }
}
