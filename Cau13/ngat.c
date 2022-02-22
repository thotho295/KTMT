/*
 * ngat.c
 *
 * Created: 11/12/2021 9:23:04 SA
 * Author: admin
 */

#include <io.h>

#define LED PORTD.4

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
    LED = !LED;
}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
    LED = !LED;
}

// External Interrupt 2 service routine
interrupt [EXT_INT2] void ext_int2_isr(void)
{
    LED = !LED;
}

// External Interrupt 3 service routine
interrupt [EXT_INT3] void ext_int3_isr(void)
{
    LED = !LED;
}

// External Interrupt 4 service routine
interrupt [EXT_INT4] void ext_int4_isr(void)
{
    LED = !LED;
}

// External Interrupt 5 service routine
interrupt [EXT_INT5] void ext_int5_isr(void)
{
    LED = !LED;
}

// External Interrupt 6 service routine
interrupt [EXT_INT6] void ext_int6_isr(void)
{
    LED = !LED;
}

// External Interrupt 7 service routine
interrupt [EXT_INT7] void ext_int7_isr(void)
{
    LED = !LED;
}


void main(void){
    DDRD = 0x10;
    DDRE = 0x00;
    
    PORTD = 0x0f;
    PORTE = 0xf0;

    // Timer(s)/Counter(s) Interrupt(s) initialization
//    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
//    ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
                                                                                               
    // External Interrupt(s) initialization
    // INT0: On
    // INT0 Mode: Low level
    // INT1: On
    // INT1 Mode: Low level
    // INT2: On
    // INT2 Mode: Low level
    // INT3: On
    // INT3 Mode: Low level
    // INT4: On
    // INT4 Mode: Low level
    // INT5: On
    // INT5 Mode: Low level
    // INT6: On
    // INT6 Mode: Low level
    // INT7: On
    // INT7 Mode: Low level
//    EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
//    EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
    EIMSK=(1<<INT7) | (1<<INT6) | (1<<INT5) | (1<<INT4) | (1<<INT3) | (1<<INT2) | (1<<INT1) | (1<<INT0);
    EIFR=(1<<INTF7) | (1<<INTF6) | (1<<INTF5) | (1<<INTF4) | (1<<INTF3) | (1<<INTF2) | (1<<INTF1) | (1<<INTF0);

    // Global enable interrupts
    #asm("sei")
    while (1){

    }
}
