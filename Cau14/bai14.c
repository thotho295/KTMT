#include <io.h>
#include <alcd.h>
#include <delay.h>
#include <stdlib.h>
#include <stdio.h>

#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))

unsigned char buffer[15];
unsigned int threshold=485,count=0;

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input){
    ADMUX=adc_input | ADC_VREF_TYPE;
    // Delay needed for the stabilization of the ADC input voltage
    delay_us(10);
    // Start the AD conversion
    ADCSRA|=(1<<ADSC);
    // Wait for the AD conversion to complete
    while ((ADCSRA & (1<<ADIF))==0);
    ADCSRA|=(1<<ADIF);
 
    return ADCW;
}


void render(){
    lcd_clear();                              
    sprintf(buffer,"Value: %u",read_adc(0));
    lcd_gotoxy(0,0);
    lcd_puts(buffer);
    sprintf(buffer,"Threshold: %u",threshold);        
    lcd_gotoxy(0,1);
    lcd_puts(buffer);
}

interrupt [TIM0_OVF] void timer0_ovf_isr(void){
    TCNT0=0x06;
    if(++count > 300){
      count=0,render();
      if(read_adc(0) < threshold)PORTC.3 = 1;
      else PORTC.3 = 0;
    }
}


void main(void){
    ASSR=0<<AS0;
    TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
    TCNT0=0x06;
    OCR0=0x00;

    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
    ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);

    ADMUX=ADC_VREF_TYPE;
    ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
    SFIOR=(0<<ACME);

    DDRC.3 = 1;
    PORTC.3 = 0;
    
    lcd_init(16);
    #asm("sei")
    while (1){                                     
                
    }
}
