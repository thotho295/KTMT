/*
 * cau_17.c
 *
 * Created: 1/19/2022 10:37:06 PM
 * Author: nguyen thu thao
 */

#include <io.h>
#include <alcd.h>
#include <stdio.h>

// Define function
void clean_up();

// Position in led
int cache_position[4] = {0b01011000,0b01010001,0b01001001,0b00011001};

// Define data type boolean
#define TRUE 1
#define FALSE 0

// Define BUTTON
#define BUTTON PINB.2

// Initialization variables
unsigned int minute,second,hour,day,month,year,option;
unsigned int counter,reset_counter,delay_counter,show_lcd_counter,show_led_counter;
char line_1[16],line_2[16];

// True if year is leap year
char is_leap_year(unsigned int year)
{
    if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0))
        return TRUE;
    return FALSE;
} 

// Get day in month of year
int day_in_month_of_year(unsigned int month, unsigned int year)
{
    switch(month)
    {
        case 1:
            return 31;
        case 2:
            return is_leap_year(year) ? 29 : 28;
        case 3:
            return 31;
        case 4: 
            return 30;
        case 5:
            return 31;
        case 6:
            return 30;
        case 7:
            return 31;
        case 8:
            return 31;
        case 9:
            return 30;
        case 10:
            return 31;
        case 11:
            return 30;
        case 12:
            return 31;
    } 
    return 0;   
}


void show_lcd()
{
    sprintf(line_1,"%d:%d:%d",hour,minute,second);   
    sprintf(line_2,"%d:%d:%d",day,month,year);
    lcd_clear();  
    lcd_gotoxy(0,0);
    lcd_puts(line_1);
    lcd_gotoxy(0,1);
    lcd_puts(line_2);
}

void show_led(int number,int position,char dot)
{
    int cache_dot = dot ? 0b10000000 : 0b00000000;   
    if (number == 0)
    {
        PORTF = cache_dot + cache_position[position - 1] + 0b00100110;
        PORTD = 0b00000110;
        PORTA.7 = 1;           
    }  
    else if (number == 1)
    {    
        PORTF = cache_dot + cache_position[position - 1] + 0b00100000;
        PORTD = 0x00;
        PORTA.7 = 1;
    }   
    else if (number == 2)
    {  
        PORTF = cache_dot + cache_position[position - 1] + 0b00100010;
        PORTD = 0x0E;
        PORTA.7 = 0;
    }
    else if (number == 3)
    {     
        PORTF = cache_dot + cache_position[position - 1] + 0b00100010;
        PORTD = 0x0A;
        PORTA.7 = 1;
    }
    else if (number == 4)
    {     
        PORTF = cache_dot + cache_position[position - 1] + 0b00100100;
        PORTD = 0b00001000;
        PORTA.7 = 1;
    }
    else if (number == 5)
    {      
        PORTF = cache_dot + cache_position[position - 1] + 0b00000110;
        PORTD = 0b00001010;
        PORTA.7 = 1;
    }
    else if (number == 6)
    {      
        PORTF = cache_dot + cache_position[position - 1] + 0b00000110;
        PORTD = 0b00001110;
        PORTA.7 = 1;
    }
    else if (number == 7)
    {  
        PORTF = cache_dot + cache_position[position - 1] + 0b00100010;
        PORTD = 0b00000000;
        PORTA.7 = 1;
    }                    
    else if (number == 8)
    {   
        PORTF = cache_dot + cache_position[position - 1] + 0b00100110;
        PORTD = 0b00001110;
        PORTA.7 = 1;
    } 
    else if (number == 9)
    {   
        PORTF = cache_dot + cache_position[position - 1] + 0b00100110;
        PORTD = 0b00001010;
        PORTA.7 = 1;
    }
    else 
    {
        PORTF = cache_dot + cache_position[position - 1] + 0x00;
        PORTD = 0x00;
        PORTA.7 = 0;
    }   
}



interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    TCNT0=0x06; 
    // Counter 
    show_lcd_counter++;   
    show_led_counter++; 
    if (delay_counter>=0)
    {
        delay_counter++;
    }
                  
    
    if (show_lcd_counter > 500)
    {           
        show_lcd_counter = 0;
        show_lcd();
    }  
    
    if (option == 0)
    {     
        reset_counter = 0;
        counter++;
        if (counter>1000)
        {
            counter = 0;
            second++;
            clean_up();      
        }
    }  
    else
    {
        reset_counter++;
        if (reset_counter >= 3000)
        {              
            reset_counter = 0;
            option = 0;   
        }
    } 
       
    
    // Handler LED
    if (option == 0)
    {
        int _1 = hour/10;
        int _2 = hour%10;
        int _3 = minute/10;
        int _4 = minute%10;
        if (show_led_counter >= 0 && show_led_counter < 10)
        {
            show_led(_1,1,FALSE);
        }
        else if (show_led_counter >= 10 && show_led_counter < 20)
        {                        
            if (second % 2 == 0)
            {
                show_led(_2,2,FALSE);
            }
            else
            {
                show_led(_2,2,TRUE);
            }
        }
        else if (show_led_counter >= 20 && show_led_counter < 30)
        {
            show_led(_3,3,FALSE);
        }
        else if (show_led_counter >= 30 && show_led_counter < 40)
        {
            show_led(_4,4,FALSE);
        }
        else
            show_led_counter = 0;
    }
    else if (option == 1)
    {
        int _1 = hour/10;
        int _2 = hour%10;  
        if (show_led_counter >= 0 && show_led_counter < 20)
        {
            show_led(_1,1,FALSE);
        }
        else if (show_led_counter >= 20 && show_led_counter < 40)
        {
            show_led(_2,2,FALSE);
        }
        else
            show_led_counter = 0;
    }  
    else if (option == 2)
    {
        int _3 = minute/10;
        int _4 = minute%10;  
        if (show_led_counter >= 0 && show_led_counter < 20)
        {
            show_led(_3,3,FALSE);
        }
        else if (show_led_counter >= 20 && show_led_counter < 40)
        {
            show_led(_4,4,FALSE);
        }
        else
            show_led_counter = 0;    
    }
    else if (option == 3)
    {
        int _3 = second/10;
        int _4 = second%10;  
        if (show_led_counter >= 0 && show_led_counter < 20)
        {
            show_led(_3,3,FALSE);
        }
        else if (show_led_counter >= 20 && show_led_counter < 40)
        {
            show_led(_4,4,FALSE);
        }
        else
            show_led_counter = 0; 
    }
    else if (option == 4)
    { 
        int _1 = day/10;
        int _2 = day%10;  
        if (show_led_counter >= 0 && show_led_counter < 20)
        {
            show_led(_1,1,FALSE);
        }
        else if (show_led_counter >= 20 && show_led_counter < 40)
        {
            show_led(_2,2,FALSE);
        }
        else
            show_led_counter = 0;
        
    }
    else if (option == 5)
    {
        int _3 = month/10;
        int _4 = month%10;  
        if (show_led_counter >= 0 && show_led_counter < 20)
        {
            show_led(_3,3,FALSE);
        }
        else if (show_led_counter >= 20 && show_led_counter < 40)
        {
            show_led(_4,4,FALSE);
        }
        else
            show_led_counter = 0;
        
    }  
    else if (option == 6)
    {
        int _1 = year/1000;
        int _2 = (year % 1000)/100;    
        int _3 = ((year %1000) %100)/10;
        int _4 = year%10;
        if (show_led_counter >= 0 && show_led_counter < 10)
        {
            show_led(_1,1,FALSE);
        }
        else if (show_led_counter >= 10 && show_led_counter < 20)
        {                        
            show_led(_2,2,FALSE);
        }
        else if (show_led_counter >= 20 && show_led_counter < 30)
        {
            show_led(_3,3,FALSE);
        }
        else if (show_led_counter >= 30 && show_led_counter < 40)
        {
            show_led(_4,4,FALSE);
        }
        else
            show_led_counter = 0;
    }
    

       
    
}


void clean_up()
{
    if (second>=60)
    {
        second = 0;
        minute++;
    }
    if (minute>=60)
    {
        minute = 0;
        hour++;
    }
    if (hour>=24)
    {
        hour = 0;
        day++;
    }         
    if (day > day_in_month_of_year(month,year))
    {
        day = 1; 
        month++; 
    }            
    if (month > 12)
    {
        year++;  
    }   
    if (year > 2030 || year < 2020)
        year = 2020;
}

/**
 * 1: Hour
 * 2: Minute
 * 3: Second
 * 4: Day
 * 5: Month
 * 6: Year
 */


void main(void)
{

    // Initialization LCD
    lcd_init(16);
    
     
    DDRD = 0x0E;
    DDRA.7 = 1;
    DDRF = 0xFF;
    
    // Initialization PORT & DDR
    DDRB = 0x00;
    PORTB = 0x04;

    // Initialization value of variables
    minute = 0;
    second = 0;
    hour = 0;
    day = 1;
    month = 1;
    year = 2022;
    option = 0;
    counter = 0;
    reset_counter = 0; 
    delay_counter = -1; 
    show_lcd_counter = 0;
    show_led_counter = 0; 
    
    
    // Initialization timer 1ms
    ASSR=0<<AS0;
    TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
    TCNT0=0x06;
    OCR0=0x00;
    
    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
    ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
    
    #asm("sei")
    
    while (1)
    {
        if (BUTTON == 0)
        {      
            delay_counter = 0;
            reset_counter = 0;
            while(BUTTON == 0)
            {
                reset_counter = 0;
            }
            if (delay_counter >= 500)
            {
                switch(option)
                {
                    case 1:
                        hour++;        
                        if (hour >= 24)
                            hour = 0;
                        break;
                    case 2:
                        minute++;    
                        if (minute >=60)
                            minute = 0;
                        break;
                    case 3:
                        second++;   
                        if (second >= 60)
                            second = 0;
                        break;
                    case 4:
                        day++;
                        if (day > day_in_month_of_year(month,year))
                            day = 1;
                        break;
                    case 5: 
                        month++; 
                        if (month > 12)
                            month = 1;
                        break;
                    case 6:
                        year++;
                        if (year > 2030 || year < 2020)
                            year = 2020;
                        break;
                }             
            } 
            else
            {   
                option++;  
                if (option > 6)
                    option = 0; 
                show_led_counter = 0;
            }
            delay_counter = -1;
        }    
    }
}