/*
 * Cau17.c
 *
 * Created: 1/18/2022 10:09:25 AM
 * Author: nguyen thu thao
 */

#include <io.h>
#include <i2c.h>
#include <delay.h>
#include <stdio.h>
#include <ds1307.h>
#include <alcd.h>   // goi thu vien alpha lcd vao trong bien dich 
#define SegOne   0x01
#define SegTwo   0x02
#define SegThree 0x04
#define SegFour  0x08
#define BT PINC.0
int choice=1;
int tmp;
int dem,dem1,dem2,dem3;    
unsigned char buff [16];
int edit_mode;
unsigned char day,month,year,date, hour, minute, second;

//0:second 1:minute 2:hour 3:day 4:month 5:year

    
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{

// Reinitialize Timer 0 value
TCNT0=0x06;
// Place your code here
dem++;
dem2++;

     if(BT == 0 && edit_mode == 1){
        dem1=0;
        dem3++;
        if(dem3>=600){  

            if(dem2%200==0){
            switch(choice)
            {
                case 0:
                    second = (second+1)%60;dem=60;break;

                case 1:
                    minute = (minute+1)%60;break;

                case 2:
                    hour = (hour+1)%24;break;

                case 3:
                    if(month == 1 || month == 3||month == 5 || month == 7||month == 8 || month == 10||month == 12){
                            day = (day+1)%31;
                            if(day==0)day=31;break;
                    } 
                    if(month == 4 || month == 6||month == 9 || month == 11){
                            day = (day+1)%30;
                            if(day==0)day=30;break;
                    }
                    if(month == 2){
                        if(year==20 || year ==24|| year ==28){
                            day = (day+1)%29;
                            if(day==0)day=29;break;
                        }
                        else{
                            day = (day+1)%28;
                            if(day==0)day=28;break;
                        }
                    }
                
                case 4:
                    month = (month+1)%12;
                    if (month == 0){month =12;}
                    break;
                case 5:
                    year = ((year-20+1)%11) +20;break;
            }
            }
            tmp = choice;
        }
           
        else if(dem3 <600) { 
        tmp = (choice+1)%6; 
        
        }
        
     }
     if(BT == 1 && edit_mode == 1){ 
        dem3=0;
        dem1++;  
        choice = tmp;
        if(dem1 >= 3000){
            edit_mode = 0;
            rtc_set_date(date,day,month,year);   
            rtc_set_time(hour,minute,second);
        }
                
     }
    
}

void main() {
    char seg_code[]={0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90}; 
    char seg_code2[]={0xc0,0x79,0x24,0x30,0x19,0x12,0x02,0x78,0x00,0x10};
    
    int minute_1, minute_2,second_1,second_2; 
    
    edit_mode = 0;  
    lcd_init(16);

    DDRB = 0xff; // Data lines
    DDRD = 0xff; // Control signal PORTD0-PORTD3     
    i2c_init();
    rtc_init(3,1,0);   
    DDRC = 0x00; 
    PINC.0 =1;             
    ASSR=0<<AS0;
    TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
    TCNT0=0x06;
    OCR0=0x00;
    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
    ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
    #asm("sei")      
    
    while(1)
    {    
        if(edit_mode !=1){
        rtc_get_date(&date,&day,&month,&year);   
        rtc_get_time(&hour, &minute,&second); 
        
        } 
        minute_1 = minute / 10;
        minute_2 = minute - minute_1 * 10;
        second_1 = second / 10;
        second_2 = second - second_1 * 10;    
        if(BT == 0 && edit_mode == 0)
        {      
            dem = 0;
            while (BT == 0){                 //Cho nut nhan duoc tha
                 if(dem == 800){
                    dem = 0;
                    edit_mode = 1; 
                    break;   
                 }
            } 
        }

        PORTD = SegOne; 
        PORTB = seg_code[minute_1];
        
        if( choice ==1 && edit_mode ==1 && dem%2==0)  {
            PORTB = 0xff;
            delay_ms(2);
        }else delay_ms(10);
        
        PORTD = SegTwo; 
        PORTB = seg_code2[minute_2];
        
        if( choice ==1 && edit_mode ==1 && dem%2==0)  {
            PORTB = 0xff;
            delay_ms(2);
        }else delay_ms(10);

        
        PORTD = SegThree; 
        PORTB = seg_code[second_1]; 
        
        if( choice ==0 && edit_mode ==1 && dem%2==0)  {
            PORTB = 0xff;
            delay_ms(2);
        }else delay_ms(10); 
        
        PORTD = SegFour; 
        PORTB = seg_code[second_2];
         
        if( choice ==0 && edit_mode ==1 && dem%2==0)  {
            PORTB = 0xff;
            delay_ms(2);
        }else delay_ms(10);
        
        lcd_gotoxy(0,0);     
        sprintf(buff,"%02d:%02d:%02d:%02d",hour,day,month,year); 
        lcd_puts(buff);  
        delay_ms(10); 
        if(edit_mode == 1 && choice > 1){ 
            if(dem%5 ==0){
                lcd_gotoxy(3*(choice-2),0); 
                lcd_putchar(' ');   
                lcd_gotoxy(3*(choice-2)+1,0); 
                lcd_putchar(' ');
            }
        }

    }
}