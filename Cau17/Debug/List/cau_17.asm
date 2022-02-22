
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega128A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega128A
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _minute=R4
	.DEF _minute_msb=R5
	.DEF _second=R6
	.DEF _second_msb=R7
	.DEF _hour=R8
	.DEF _hour_msb=R9
	.DEF _day=R10
	.DEF _day_msb=R11
	.DEF _month=R12
	.DEF _month_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x58,0x0,0x51,0x0,0x49,0x0,0x19
_0x0:
	.DB  0x25,0x64,0x3A,0x25,0x64,0x3A,0x25,0x64
	.DB  0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x07
	.DW  _cache_position
	.DW  _0x3*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*
; * cau_17.c
; *
; * Created: 1/19/2022 10:37:06 PM
; * Author: nguyen thu thao
; */
;
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#include <stdio.h>
;
;// Define function
;void clean_up();
;
;// Position in led
;int cache_position[4] = {0b01011000,0b01010001,0b01001001,0b00011001};

	.DSEG
;
;// Define data type boolean
;#define TRUE 1
;#define FALSE 0
;
;// Define BUTTON
;#define BUTTON PINB.2
;
;// Initialization variables
;unsigned int minute,second,hour,day,month,year,option;
;unsigned int counter,reset_counter,delay_counter,show_lcd_counter,show_led_counter;
;char line_1[16],line_2[16];
;
;// True if year is leap year
;char is_leap_year(unsigned int year)
; 0000 0020 {

	.CSEG
_is_leap_year:
; .FSTART _is_leap_year
; 0000 0021     if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0))
	ST   -Y,R27
	ST   -Y,R26
;	year -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CALL __MODW21U
	SBIW R30,0
	BREQ _0x5
	LD   R30,Y
	ANDI R30,LOW(0x3)
	BRNE _0x6
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	SBIW R30,0
	BRNE _0x5
_0x6:
	RJMP _0x4
_0x5:
; 0000 0022         return TRUE;
	LDI  R30,LOW(1)
	JMP  _0x2080003
; 0000 0023     return FALSE;
_0x4:
	LDI  R30,LOW(0)
	JMP  _0x2080003
; 0000 0024 }
; .FEND
;
;// Get day in month of year
;int day_in_month_of_year(unsigned int month, unsigned int year)
; 0000 0028 {
_day_in_month_of_year:
; .FSTART _day_in_month_of_year
; 0000 0029     switch(month)
	ST   -Y,R27
	ST   -Y,R26
;	month -> Y+2
;	year -> Y+0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
; 0000 002A     {
; 0000 002B         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xC
; 0000 002C             return 31;
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	RJMP _0x2080004
; 0000 002D         case 2:
_0xC:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xD
; 0000 002E             return is_leap_year(year) ? 29 : 28;
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _is_leap_year
	CPI  R30,0
	BREQ _0xE
	LDI  R30,LOW(29)
	LDI  R31,HIGH(29)
	RJMP _0xF
_0xE:
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
_0xF:
	RJMP _0x2080004
; 0000 002F         case 3:
_0xD:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x11
; 0000 0030             return 31;
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	RJMP _0x2080004
; 0000 0031         case 4:
_0x11:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x12
; 0000 0032             return 30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RJMP _0x2080004
; 0000 0033         case 5:
_0x12:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x13
; 0000 0034             return 31;
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	RJMP _0x2080004
; 0000 0035         case 6:
_0x13:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x14
; 0000 0036             return 30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RJMP _0x2080004
; 0000 0037         case 7:
_0x14:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x15
; 0000 0038             return 31;
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	RJMP _0x2080004
; 0000 0039         case 8:
_0x15:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x16
; 0000 003A             return 31;
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	RJMP _0x2080004
; 0000 003B         case 9:
_0x16:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x17
; 0000 003C             return 30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RJMP _0x2080004
; 0000 003D         case 10:
_0x17:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x18
; 0000 003E             return 31;
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	RJMP _0x2080004
; 0000 003F         case 11:
_0x18:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x19
; 0000 0040             return 30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RJMP _0x2080004
; 0000 0041         case 12:
_0x19:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xB
; 0000 0042             return 31;
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	RJMP _0x2080004
; 0000 0043     }
_0xB:
; 0000 0044     return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x2080004:
	ADIW R28,4
	RET
; 0000 0045 }
; .FEND
;
;
;void show_lcd()
; 0000 0049 {
_show_lcd:
; .FSTART _show_lcd
; 0000 004A     sprintf(line_1,"%d:%d:%d",hour,minute,second);
	LDI  R30,LOW(_line_1)
	LDI  R31,HIGH(_line_1)
	CALL SUBOPT_0x0
	MOVW R30,R8
	CALL SUBOPT_0x1
	MOVW R30,R4
	CALL SUBOPT_0x1
	MOVW R30,R6
	CALL SUBOPT_0x1
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 004B     sprintf(line_2,"%d:%d:%d",day,month,year);
	LDI  R30,LOW(_line_2)
	LDI  R31,HIGH(_line_2)
	CALL SUBOPT_0x0
	MOVW R30,R10
	CALL SUBOPT_0x1
	MOVW R30,R12
	CALL SUBOPT_0x1
	LDS  R30,_year
	LDS  R31,_year+1
	CALL SUBOPT_0x1
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 004C     lcd_clear();
	CALL _lcd_clear
; 0000 004D     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 004E     lcd_puts(line_1);
	LDI  R26,LOW(_line_1)
	LDI  R27,HIGH(_line_1)
	CALL _lcd_puts
; 0000 004F     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0050     lcd_puts(line_2);
	LDI  R26,LOW(_line_2)
	LDI  R27,HIGH(_line_2)
	CALL _lcd_puts
; 0000 0051 }
	RET
; .FEND
;
;void show_led(int number,int position,char dot)
; 0000 0054 {
_show_led:
; .FSTART _show_led
; 0000 0055     int cache_dot = dot ? 0b10000000 : 0b00000000;
; 0000 0056     if (number == 0)
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	number -> Y+5
;	position -> Y+3
;	dot -> Y+2
;	cache_dot -> R16,R17
	LDD  R30,Y+2
	LDI  R31,0
	SBIW R30,0
	BREQ _0x1B
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	RJMP _0x1C
_0x1B:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x1C:
	MOVW R16,R30
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	SBIW R30,0
	BRNE _0x1E
; 0000 0057     {
; 0000 0058         PORTF = cache_dot + cache_position[position - 1] + 0b00100110;
	CALL SUBOPT_0x2
	SUBI R30,-LOW(38)
	STS  98,R30
; 0000 0059         PORTD = 0b00000110;
	LDI  R30,LOW(6)
	OUT  0x12,R30
; 0000 005A         PORTA.7 = 1;
	SBI  0x1B,7
; 0000 005B     }
; 0000 005C     else if (number == 1)
	RJMP _0x21
_0x1E:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	SBIW R26,1
	BRNE _0x22
; 0000 005D     {
; 0000 005E         PORTF = cache_dot + cache_position[position - 1] + 0b00100000;
	CALL SUBOPT_0x2
	SUBI R30,-LOW(32)
	STS  98,R30
; 0000 005F         PORTD = 0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0060         PORTA.7 = 1;
	SBI  0x1B,7
; 0000 0061     }
; 0000 0062     else if (number == 2)
	RJMP _0x25
_0x22:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	SBIW R26,2
	BRNE _0x26
; 0000 0063     {
; 0000 0064         PORTF = cache_dot + cache_position[position - 1] + 0b00100010;
	CALL SUBOPT_0x2
	SUBI R30,-LOW(34)
	STS  98,R30
; 0000 0065         PORTD = 0x0E;
	LDI  R30,LOW(14)
	RJMP _0xCB
; 0000 0066         PORTA.7 = 0;
; 0000 0067     }
; 0000 0068     else if (number == 3)
_0x26:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	SBIW R26,3
	BRNE _0x2A
; 0000 0069     {
; 0000 006A         PORTF = cache_dot + cache_position[position - 1] + 0b00100010;
	CALL SUBOPT_0x2
	SUBI R30,-LOW(34)
	CALL SUBOPT_0x3
; 0000 006B         PORTD = 0x0A;
; 0000 006C         PORTA.7 = 1;
; 0000 006D     }
; 0000 006E     else if (number == 4)
	RJMP _0x2D
_0x2A:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	SBIW R26,4
	BRNE _0x2E
; 0000 006F     {
; 0000 0070         PORTF = cache_dot + cache_position[position - 1] + 0b00100100;
	CALL SUBOPT_0x2
	SUBI R30,-LOW(36)
	STS  98,R30
; 0000 0071         PORTD = 0b00001000;
	LDI  R30,LOW(8)
	OUT  0x12,R30
; 0000 0072         PORTA.7 = 1;
	SBI  0x1B,7
; 0000 0073     }
; 0000 0074     else if (number == 5)
	RJMP _0x31
_0x2E:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	SBIW R26,5
	BRNE _0x32
; 0000 0075     {
; 0000 0076         PORTF = cache_dot + cache_position[position - 1] + 0b00000110;
	CALL SUBOPT_0x2
	SUBI R30,-LOW(6)
	CALL SUBOPT_0x3
; 0000 0077         PORTD = 0b00001010;
; 0000 0078         PORTA.7 = 1;
; 0000 0079     }
; 0000 007A     else if (number == 6)
	RJMP _0x35
_0x32:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	SBIW R26,6
	BRNE _0x36
; 0000 007B     {
; 0000 007C         PORTF = cache_dot + cache_position[position - 1] + 0b00000110;
	CALL SUBOPT_0x2
	SUBI R30,-LOW(6)
	STS  98,R30
; 0000 007D         PORTD = 0b00001110;
	LDI  R30,LOW(14)
	OUT  0x12,R30
; 0000 007E         PORTA.7 = 1;
	SBI  0x1B,7
; 0000 007F     }
; 0000 0080     else if (number == 7)
	RJMP _0x39
_0x36:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	SBIW R26,7
	BRNE _0x3A
; 0000 0081     {
; 0000 0082         PORTF = cache_dot + cache_position[position - 1] + 0b00100010;
	CALL SUBOPT_0x2
	SUBI R30,-LOW(34)
	STS  98,R30
; 0000 0083         PORTD = 0b00000000;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0084         PORTA.7 = 1;
	SBI  0x1B,7
; 0000 0085     }
; 0000 0086     else if (number == 8)
	RJMP _0x3D
_0x3A:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	SBIW R26,8
	BRNE _0x3E
; 0000 0087     {
; 0000 0088         PORTF = cache_dot + cache_position[position - 1] + 0b00100110;
	CALL SUBOPT_0x2
	SUBI R30,-LOW(38)
	STS  98,R30
; 0000 0089         PORTD = 0b00001110;
	LDI  R30,LOW(14)
	OUT  0x12,R30
; 0000 008A         PORTA.7 = 1;
	SBI  0x1B,7
; 0000 008B     }
; 0000 008C     else if (number == 9)
	RJMP _0x41
_0x3E:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	SBIW R26,9
	BRNE _0x42
; 0000 008D     {
; 0000 008E         PORTF = cache_dot + cache_position[position - 1] + 0b00100110;
	CALL SUBOPT_0x2
	SUBI R30,-LOW(38)
	CALL SUBOPT_0x3
; 0000 008F         PORTD = 0b00001010;
; 0000 0090         PORTA.7 = 1;
; 0000 0091     }
; 0000 0092     else
	RJMP _0x45
_0x42:
; 0000 0093     {
; 0000 0094         PORTF = cache_dot + cache_position[position - 1] + 0x00;
	CALL SUBOPT_0x2
	STS  98,R30
; 0000 0095         PORTD = 0x00;
	LDI  R30,LOW(0)
_0xCB:
	OUT  0x12,R30
; 0000 0096         PORTA.7 = 0;
	CBI  0x1B,7
; 0000 0097     }
_0x45:
_0x41:
_0x3D:
_0x39:
_0x35:
_0x31:
_0x2D:
_0x25:
_0x21:
; 0000 0098 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
; .FEND
;
;
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 009D {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 009E     TCNT0=0x06;
	LDI  R30,LOW(6)
	OUT  0x32,R30
; 0000 009F     // Counter
; 0000 00A0     show_lcd_counter++;
	LDI  R26,LOW(_show_lcd_counter)
	LDI  R27,HIGH(_show_lcd_counter)
	CALL SUBOPT_0x4
; 0000 00A1     show_led_counter++;
	LDI  R26,LOW(_show_led_counter)
	LDI  R27,HIGH(_show_led_counter)
	CALL SUBOPT_0x4
; 0000 00A2     if (delay_counter>=0)
	LDS  R26,_delay_counter
	LDS  R27,_delay_counter+1
	SBIW R26,0
	BRLO _0x48
; 0000 00A3     {
; 0000 00A4         delay_counter++;
	LDI  R26,LOW(_delay_counter)
	LDI  R27,HIGH(_delay_counter)
	CALL SUBOPT_0x4
; 0000 00A5     }
; 0000 00A6 
; 0000 00A7 
; 0000 00A8     if (show_lcd_counter > 500)
_0x48:
	LDS  R26,_show_lcd_counter
	LDS  R27,_show_lcd_counter+1
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLO _0x49
; 0000 00A9     {
; 0000 00AA         show_lcd_counter = 0;
	LDI  R30,LOW(0)
	STS  _show_lcd_counter,R30
	STS  _show_lcd_counter+1,R30
; 0000 00AB         show_lcd();
	RCALL _show_lcd
; 0000 00AC     }
; 0000 00AD 
; 0000 00AE     if (option == 0)
_0x49:
	LDS  R30,_option
	LDS  R31,_option+1
	SBIW R30,0
	BRNE _0x4A
; 0000 00AF     {
; 0000 00B0         reset_counter = 0;
	CALL SUBOPT_0x5
; 0000 00B1         counter++;
	LDI  R26,LOW(_counter)
	LDI  R27,HIGH(_counter)
	CALL SUBOPT_0x4
; 0000 00B2         if (counter>1000)
	LDS  R26,_counter
	LDS  R27,_counter+1
	CPI  R26,LOW(0x3E9)
	LDI  R30,HIGH(0x3E9)
	CPC  R27,R30
	BRLO _0x4B
; 0000 00B3         {
; 0000 00B4             counter = 0;
	LDI  R30,LOW(0)
	STS  _counter,R30
	STS  _counter+1,R30
; 0000 00B5             second++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 00B6             clean_up();
	RCALL _clean_up
; 0000 00B7         }
; 0000 00B8     }
_0x4B:
; 0000 00B9     else
	RJMP _0x4C
_0x4A:
; 0000 00BA     {
; 0000 00BB         reset_counter++;
	LDI  R26,LOW(_reset_counter)
	LDI  R27,HIGH(_reset_counter)
	CALL SUBOPT_0x4
; 0000 00BC         if (reset_counter >= 3000)
	LDS  R26,_reset_counter
	LDS  R27,_reset_counter+1
	CPI  R26,LOW(0xBB8)
	LDI  R30,HIGH(0xBB8)
	CPC  R27,R30
	BRLO _0x4D
; 0000 00BD         {
; 0000 00BE             reset_counter = 0;
	CALL SUBOPT_0x5
; 0000 00BF             option = 0;
	CALL SUBOPT_0x6
; 0000 00C0         }
; 0000 00C1     }
_0x4D:
_0x4C:
; 0000 00C2 
; 0000 00C3 
; 0000 00C4     // Handler LED
; 0000 00C5     if (option == 0)
	LDS  R30,_option
	LDS  R31,_option+1
	SBIW R30,0
	BREQ PC+2
	RJMP _0x4E
; 0000 00C6     {
; 0000 00C7         int _1 = hour/10;
; 0000 00C8         int _2 = hour%10;
; 0000 00C9         int _3 = minute/10;
; 0000 00CA         int _4 = minute%10;
; 0000 00CB         if (show_led_counter >= 0 && show_led_counter < 10)
	SBIW R28,8
;	_1 -> Y+6
;	_2 -> Y+4
;	_3 -> Y+2
;	_4 -> Y+0
	MOVW R26,R8
	CALL SUBOPT_0x7
	STD  Y+6,R30
	STD  Y+6+1,R31
	MOVW R26,R8
	CALL SUBOPT_0x8
	STD  Y+4,R30
	STD  Y+4+1,R31
	MOVW R26,R4
	CALL SUBOPT_0x7
	STD  Y+2,R30
	STD  Y+2+1,R31
	MOVW R26,R4
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	BRLO _0x50
	CALL SUBOPT_0xA
	BRLO _0x51
_0x50:
	RJMP _0x4F
_0x51:
; 0000 00CC         {
; 0000 00CD             show_led(_1,1,FALSE);
	CALL SUBOPT_0xB
; 0000 00CE         }
; 0000 00CF         else if (show_led_counter >= 10 && show_led_counter < 20)
	RJMP _0x52
_0x4F:
	CALL SUBOPT_0xA
	BRLO _0x54
	CALL SUBOPT_0xC
	BRLO _0x55
_0x54:
	RJMP _0x53
_0x55:
; 0000 00D0         {
; 0000 00D1             if (second % 2 == 0)
	MOVW R30,R6
	ANDI R30,LOW(0x1)
	BRNE _0x56
; 0000 00D2             {
; 0000 00D3                 show_led(_2,2,FALSE);
	CALL SUBOPT_0xD
	LDI  R26,LOW(0)
	RJMP _0xCC
; 0000 00D4             }
; 0000 00D5             else
_0x56:
; 0000 00D6             {
; 0000 00D7                 show_led(_2,2,TRUE);
	CALL SUBOPT_0xD
	LDI  R26,LOW(1)
_0xCC:
	RCALL _show_led
; 0000 00D8             }
; 0000 00D9         }
; 0000 00DA         else if (show_led_counter >= 20 && show_led_counter < 30)
	RJMP _0x58
_0x53:
	CALL SUBOPT_0xC
	BRLO _0x5A
	CALL SUBOPT_0xE
	BRLO _0x5B
_0x5A:
	RJMP _0x59
_0x5B:
; 0000 00DB         {
; 0000 00DC             show_led(_3,3,FALSE);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 00DD         }
; 0000 00DE         else if (show_led_counter >= 30 && show_led_counter < 40)
	RJMP _0x5C
_0x59:
	CALL SUBOPT_0xE
	BRLO _0x5E
	CALL SUBOPT_0x11
	BRLO _0x5F
_0x5E:
	RJMP _0x5D
_0x5F:
; 0000 00DF         {
; 0000 00E0             show_led(_4,4,FALSE);
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
; 0000 00E1         }
; 0000 00E2         else
	RJMP _0x60
_0x5D:
; 0000 00E3             show_led_counter = 0;
	CALL SUBOPT_0x14
; 0000 00E4     }
_0x60:
_0x5C:
_0x58:
_0x52:
	RJMP _0xCD
; 0000 00E5     else if (option == 1)
_0x4E:
	CALL SUBOPT_0x15
	SBIW R26,1
	BRNE _0x62
; 0000 00E6     {
; 0000 00E7         int _1 = hour/10;
; 0000 00E8         int _2 = hour%10;
; 0000 00E9         if (show_led_counter >= 0 && show_led_counter < 20)
	SBIW R28,4
;	_1 -> Y+2
;	_2 -> Y+0
	MOVW R26,R8
	CALL SUBOPT_0x7
	STD  Y+2,R30
	STD  Y+2+1,R31
	MOVW R26,R8
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	BRLO _0x64
	CALL SUBOPT_0xC
	BRLO _0x65
_0x64:
	RJMP _0x63
_0x65:
; 0000 00EA         {
; 0000 00EB             show_led(_1,1,FALSE);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x16
; 0000 00EC         }
; 0000 00ED         else if (show_led_counter >= 20 && show_led_counter < 40)
	RJMP _0x66
_0x63:
	CALL SUBOPT_0xC
	BRLO _0x68
	CALL SUBOPT_0x11
	BRLO _0x69
_0x68:
	RJMP _0x67
_0x69:
; 0000 00EE         {
; 0000 00EF             show_led(_2,2,FALSE);
	CALL SUBOPT_0x12
	CALL SUBOPT_0x17
; 0000 00F0         }
; 0000 00F1         else
	RJMP _0x6A
_0x67:
; 0000 00F2             show_led_counter = 0;
	CALL SUBOPT_0x14
; 0000 00F3     }
_0x6A:
_0x66:
	ADIW R28,4
; 0000 00F4     else if (option == 2)
	RJMP _0x6B
_0x62:
	CALL SUBOPT_0x15
	SBIW R26,2
	BRNE _0x6C
; 0000 00F5     {
; 0000 00F6         int _3 = minute/10;
; 0000 00F7         int _4 = minute%10;
; 0000 00F8         if (show_led_counter >= 0 && show_led_counter < 20)
	SBIW R28,4
;	_3 -> Y+2
;	_4 -> Y+0
	MOVW R26,R4
	CALL SUBOPT_0x7
	STD  Y+2,R30
	STD  Y+2+1,R31
	MOVW R26,R4
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	BRLO _0x6E
	CALL SUBOPT_0xC
	BRLO _0x6F
_0x6E:
	RJMP _0x6D
_0x6F:
; 0000 00F9         {
; 0000 00FA             show_led(_3,3,FALSE);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 00FB         }
; 0000 00FC         else if (show_led_counter >= 20 && show_led_counter < 40)
	RJMP _0x70
_0x6D:
	CALL SUBOPT_0xC
	BRLO _0x72
	CALL SUBOPT_0x11
	BRLO _0x73
_0x72:
	RJMP _0x71
_0x73:
; 0000 00FD         {
; 0000 00FE             show_led(_4,4,FALSE);
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
; 0000 00FF         }
; 0000 0100         else
	RJMP _0x74
_0x71:
; 0000 0101             show_led_counter = 0;
	CALL SUBOPT_0x14
; 0000 0102     }
_0x74:
_0x70:
	ADIW R28,4
; 0000 0103     else if (option == 3)
	RJMP _0x75
_0x6C:
	CALL SUBOPT_0x15
	SBIW R26,3
	BRNE _0x76
; 0000 0104     {
; 0000 0105         int _3 = second/10;
; 0000 0106         int _4 = second%10;
; 0000 0107         if (show_led_counter >= 0 && show_led_counter < 20)
	SBIW R28,4
;	_3 -> Y+2
;	_4 -> Y+0
	MOVW R26,R6
	CALL SUBOPT_0x7
	STD  Y+2,R30
	STD  Y+2+1,R31
	MOVW R26,R6
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	BRLO _0x78
	CALL SUBOPT_0xC
	BRLO _0x79
_0x78:
	RJMP _0x77
_0x79:
; 0000 0108         {
; 0000 0109             show_led(_3,3,FALSE);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 010A         }
; 0000 010B         else if (show_led_counter >= 20 && show_led_counter < 40)
	RJMP _0x7A
_0x77:
	CALL SUBOPT_0xC
	BRLO _0x7C
	CALL SUBOPT_0x11
	BRLO _0x7D
_0x7C:
	RJMP _0x7B
_0x7D:
; 0000 010C         {
; 0000 010D             show_led(_4,4,FALSE);
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
; 0000 010E         }
; 0000 010F         else
	RJMP _0x7E
_0x7B:
; 0000 0110             show_led_counter = 0;
	CALL SUBOPT_0x14
; 0000 0111     }
_0x7E:
_0x7A:
	ADIW R28,4
; 0000 0112     else if (option == 4)
	RJMP _0x7F
_0x76:
	CALL SUBOPT_0x15
	SBIW R26,4
	BRNE _0x80
; 0000 0113     {
; 0000 0114         int _1 = day/10;
; 0000 0115         int _2 = day%10;
; 0000 0116         if (show_led_counter >= 0 && show_led_counter < 20)
	SBIW R28,4
;	_1 -> Y+2
;	_2 -> Y+0
	MOVW R26,R10
	CALL SUBOPT_0x7
	STD  Y+2,R30
	STD  Y+2+1,R31
	MOVW R26,R10
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	BRLO _0x82
	CALL SUBOPT_0xC
	BRLO _0x83
_0x82:
	RJMP _0x81
_0x83:
; 0000 0117         {
; 0000 0118             show_led(_1,1,FALSE);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x16
; 0000 0119         }
; 0000 011A         else if (show_led_counter >= 20 && show_led_counter < 40)
	RJMP _0x84
_0x81:
	CALL SUBOPT_0xC
	BRLO _0x86
	CALL SUBOPT_0x11
	BRLO _0x87
_0x86:
	RJMP _0x85
_0x87:
; 0000 011B         {
; 0000 011C             show_led(_2,2,FALSE);
	CALL SUBOPT_0x12
	CALL SUBOPT_0x17
; 0000 011D         }
; 0000 011E         else
	RJMP _0x88
_0x85:
; 0000 011F             show_led_counter = 0;
	CALL SUBOPT_0x14
; 0000 0120 
; 0000 0121     }
_0x88:
_0x84:
	ADIW R28,4
; 0000 0122     else if (option == 5)
	RJMP _0x89
_0x80:
	CALL SUBOPT_0x15
	SBIW R26,5
	BRNE _0x8A
; 0000 0123     {
; 0000 0124         int _3 = month/10;
; 0000 0125         int _4 = month%10;
; 0000 0126         if (show_led_counter >= 0 && show_led_counter < 20)
	SBIW R28,4
;	_3 -> Y+2
;	_4 -> Y+0
	MOVW R26,R12
	CALL SUBOPT_0x7
	STD  Y+2,R30
	STD  Y+2+1,R31
	MOVW R26,R12
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	BRLO _0x8C
	CALL SUBOPT_0xC
	BRLO _0x8D
_0x8C:
	RJMP _0x8B
_0x8D:
; 0000 0127         {
; 0000 0128             show_led(_3,3,FALSE);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 0129         }
; 0000 012A         else if (show_led_counter >= 20 && show_led_counter < 40)
	RJMP _0x8E
_0x8B:
	CALL SUBOPT_0xC
	BRLO _0x90
	CALL SUBOPT_0x11
	BRLO _0x91
_0x90:
	RJMP _0x8F
_0x91:
; 0000 012B         {
; 0000 012C             show_led(_4,4,FALSE);
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
; 0000 012D         }
; 0000 012E         else
	RJMP _0x92
_0x8F:
; 0000 012F             show_led_counter = 0;
	CALL SUBOPT_0x14
; 0000 0130 
; 0000 0131     }
_0x92:
_0x8E:
	ADIW R28,4
; 0000 0132     else if (option == 6)
	RJMP _0x93
_0x8A:
	CALL SUBOPT_0x15
	SBIW R26,6
	BREQ PC+2
	RJMP _0x94
; 0000 0133     {
; 0000 0134         int _1 = year/1000;
; 0000 0135         int _2 = (year % 1000)/100;
; 0000 0136         int _3 = ((year %1000) %100)/10;
; 0000 0137         int _4 = year%10;
; 0000 0138         if (show_led_counter >= 0 && show_led_counter < 10)
	SBIW R28,8
;	_1 -> Y+6
;	_2 -> Y+4
;	_3 -> Y+2
;	_4 -> Y+0
	CALL SUBOPT_0x18
	CALL __DIVW21U
	STD  Y+6,R30
	STD  Y+6+1,R31
	CALL SUBOPT_0x18
	CALL __MODW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	STD  Y+4,R30
	STD  Y+4+1,R31
	CALL SUBOPT_0x18
	CALL __MODW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	MOVW R26,R30
	CALL SUBOPT_0x7
	STD  Y+2,R30
	STD  Y+2+1,R31
	CALL SUBOPT_0x19
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	BRLO _0x96
	CALL SUBOPT_0xA
	BRLO _0x97
_0x96:
	RJMP _0x95
_0x97:
; 0000 0139         {
; 0000 013A             show_led(_1,1,FALSE);
	CALL SUBOPT_0xB
; 0000 013B         }
; 0000 013C         else if (show_led_counter >= 10 && show_led_counter < 20)
	RJMP _0x98
_0x95:
	CALL SUBOPT_0xA
	BRLO _0x9A
	CALL SUBOPT_0xC
	BRLO _0x9B
_0x9A:
	RJMP _0x99
_0x9B:
; 0000 013D         {
; 0000 013E             show_led(_2,2,FALSE);
	CALL SUBOPT_0xD
	LDI  R26,LOW(0)
	RCALL _show_led
; 0000 013F         }
; 0000 0140         else if (show_led_counter >= 20 && show_led_counter < 30)
	RJMP _0x9C
_0x99:
	CALL SUBOPT_0xC
	BRLO _0x9E
	CALL SUBOPT_0xE
	BRLO _0x9F
_0x9E:
	RJMP _0x9D
_0x9F:
; 0000 0141         {
; 0000 0142             show_led(_3,3,FALSE);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 0143         }
; 0000 0144         else if (show_led_counter >= 30 && show_led_counter < 40)
	RJMP _0xA0
_0x9D:
	CALL SUBOPT_0xE
	BRLO _0xA2
	CALL SUBOPT_0x11
	BRLO _0xA3
_0xA2:
	RJMP _0xA1
_0xA3:
; 0000 0145         {
; 0000 0146             show_led(_4,4,FALSE);
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
; 0000 0147         }
; 0000 0148         else
	RJMP _0xA4
_0xA1:
; 0000 0149             show_led_counter = 0;
	CALL SUBOPT_0x14
; 0000 014A     }
_0xA4:
_0xA0:
_0x9C:
_0x98:
_0xCD:
	ADIW R28,8
; 0000 014B 
; 0000 014C 
; 0000 014D 
; 0000 014E 
; 0000 014F }
_0x94:
_0x93:
_0x89:
_0x7F:
_0x75:
_0x6B:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;void clean_up()
; 0000 0153 {
_clean_up:
; .FSTART _clean_up
; 0000 0154     if (second>=60)
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R6,R30
	CPC  R7,R31
	BRLO _0xA5
; 0000 0155     {
; 0000 0156         second = 0;
	CLR  R6
	CLR  R7
; 0000 0157         minute++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0158     }
; 0000 0159     if (minute>=60)
_0xA5:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R4,R30
	CPC  R5,R31
	BRLO _0xA6
; 0000 015A     {
; 0000 015B         minute = 0;
	CLR  R4
	CLR  R5
; 0000 015C         hour++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 015D     }
; 0000 015E     if (hour>=24)
_0xA6:
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CP   R8,R30
	CPC  R9,R31
	BRLO _0xA7
; 0000 015F     {
; 0000 0160         hour = 0;
	CLR  R8
	CLR  R9
; 0000 0161         day++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 0162     }
; 0000 0163     if (day > day_in_month_of_year(month,year))
_0xA7:
	CALL SUBOPT_0x1A
	BRSH _0xA8
; 0000 0164     {
; 0000 0165         day = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 0166         month++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	SBIW R30,1
; 0000 0167     }
; 0000 0168     if (month > 12)
_0xA8:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R12
	CPC  R31,R13
	BRSH _0xA9
; 0000 0169     {
; 0000 016A         year++;
	LDI  R26,LOW(_year)
	LDI  R27,HIGH(_year)
	CALL SUBOPT_0x4
; 0000 016B     }
; 0000 016C     if (year > 2030 || year < 2020)
_0xA9:
	CALL SUBOPT_0x19
	CPI  R26,LOW(0x7EF)
	LDI  R30,HIGH(0x7EF)
	CPC  R27,R30
	BRSH _0xAB
	CALL SUBOPT_0x19
	CPI  R26,LOW(0x7E4)
	LDI  R30,HIGH(0x7E4)
	CPC  R27,R30
	BRSH _0xAA
_0xAB:
; 0000 016D         year = 2020;
	CALL SUBOPT_0x1B
; 0000 016E }
_0xAA:
	RET
; .FEND
;
;/**
; * 1: Hour
; * 2: Minute
; * 3: Second
; * 4: Day
; * 5: Month
; * 6: Year
; */
;
;
;void main(void)
; 0000 017B {
_main:
; .FSTART _main
; 0000 017C 
; 0000 017D     // Initialization LCD
; 0000 017E     lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 017F 
; 0000 0180 
; 0000 0181     DDRD = 0x0E;
	LDI  R30,LOW(14)
	OUT  0x11,R30
; 0000 0182     DDRA.7 = 1;
	SBI  0x1A,7
; 0000 0183     DDRF = 0xFF;
	LDI  R30,LOW(255)
	STS  97,R30
; 0000 0184 
; 0000 0185     // Initialization PORT & DDR
; 0000 0186     DDRB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 0187     PORTB = 0x04;
	LDI  R30,LOW(4)
	OUT  0x18,R30
; 0000 0188 
; 0000 0189     // Initialization value of variables
; 0000 018A     minute = 0;
	CLR  R4
	CLR  R5
; 0000 018B     second = 0;
	CLR  R6
	CLR  R7
; 0000 018C     hour = 0;
	CLR  R8
	CLR  R9
; 0000 018D     day = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 018E     month = 1;
	MOVW R12,R30
; 0000 018F     year = 2022;
	LDI  R30,LOW(2022)
	LDI  R31,HIGH(2022)
	STS  _year,R30
	STS  _year+1,R31
; 0000 0190     option = 0;
	CALL SUBOPT_0x6
; 0000 0191     counter = 0;
	LDI  R30,LOW(0)
	STS  _counter,R30
	STS  _counter+1,R30
; 0000 0192     reset_counter = 0;
	CALL SUBOPT_0x5
; 0000 0193     delay_counter = -1;
	CALL SUBOPT_0x1C
; 0000 0194     show_lcd_counter = 0;
	LDI  R30,LOW(0)
	STS  _show_lcd_counter,R30
	STS  _show_lcd_counter+1,R30
; 0000 0195     show_led_counter = 0;
	CALL SUBOPT_0x14
; 0000 0196 
; 0000 0197 
; 0000 0198     // Initialization timer 1ms
; 0000 0199     ASSR=0<<AS0;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 019A     TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 019B     TCNT0=0x06;
	LDI  R30,LOW(6)
	OUT  0x32,R30
; 0000 019C     OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0000 019D 
; 0000 019E     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 019F     ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 01A0 
; 0000 01A1     #asm("sei")
	sei
; 0000 01A2 
; 0000 01A3     while (1)
_0xAF:
; 0000 01A4     {
; 0000 01A5         if (BUTTON == 0)
	SBIC 0x16,2
	RJMP _0xB2
; 0000 01A6         {
; 0000 01A7             delay_counter = 0;
	LDI  R30,LOW(0)
	STS  _delay_counter,R30
	STS  _delay_counter+1,R30
; 0000 01A8             reset_counter = 0;
	CALL SUBOPT_0x5
; 0000 01A9             while(BUTTON == 0)
_0xB3:
	SBIC 0x16,2
	RJMP _0xB5
; 0000 01AA             {
; 0000 01AB                 reset_counter = 0;
	CALL SUBOPT_0x5
; 0000 01AC             }
	RJMP _0xB3
_0xB5:
; 0000 01AD             if (delay_counter >= 500)
	LDS  R26,_delay_counter
	LDS  R27,_delay_counter+1
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRSH PC+2
	RJMP _0xB6
; 0000 01AE             {
; 0000 01AF                 switch(option)
	LDS  R30,_option
	LDS  R31,_option+1
; 0000 01B0                 {
; 0000 01B1                     case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xBA
; 0000 01B2                         hour++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 01B3                         if (hour >= 24)
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CP   R8,R30
	CPC  R9,R31
	BRLO _0xBB
; 0000 01B4                             hour = 0;
	CLR  R8
	CLR  R9
; 0000 01B5                         break;
_0xBB:
	RJMP _0xB9
; 0000 01B6                     case 2:
_0xBA:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xBC
; 0000 01B7                         minute++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 01B8                         if (minute >=60)
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R4,R30
	CPC  R5,R31
	BRLO _0xBD
; 0000 01B9                             minute = 0;
	CLR  R4
	CLR  R5
; 0000 01BA                         break;
_0xBD:
	RJMP _0xB9
; 0000 01BB                     case 3:
_0xBC:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xBE
; 0000 01BC                         second++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 01BD                         if (second >= 60)
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R6,R30
	CPC  R7,R31
	BRLO _0xBF
; 0000 01BE                             second = 0;
	CLR  R6
	CLR  R7
; 0000 01BF                         break;
_0xBF:
	RJMP _0xB9
; 0000 01C0                     case 4:
_0xBE:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xC0
; 0000 01C1                         day++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 01C2                         if (day > day_in_month_of_year(month,year))
	CALL SUBOPT_0x1A
	BRSH _0xC1
; 0000 01C3                             day = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 01C4                         break;
_0xC1:
	RJMP _0xB9
; 0000 01C5                     case 5:
_0xC0:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xC2
; 0000 01C6                         month++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	SBIW R30,1
; 0000 01C7                         if (month > 12)
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R12
	CPC  R31,R13
	BRSH _0xC3
; 0000 01C8                             month = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 01C9                         break;
_0xC3:
	RJMP _0xB9
; 0000 01CA                     case 6:
_0xC2:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xB9
; 0000 01CB                         year++;
	LDI  R26,LOW(_year)
	LDI  R27,HIGH(_year)
	CALL SUBOPT_0x4
; 0000 01CC                         if (year > 2030 || year < 2020)
	CALL SUBOPT_0x19
	CPI  R26,LOW(0x7EF)
	LDI  R30,HIGH(0x7EF)
	CPC  R27,R30
	BRSH _0xC6
	CALL SUBOPT_0x19
	CPI  R26,LOW(0x7E4)
	LDI  R30,HIGH(0x7E4)
	CPC  R27,R30
	BRSH _0xC5
_0xC6:
; 0000 01CD                             year = 2020;
	CALL SUBOPT_0x1B
; 0000 01CE                         break;
_0xC5:
; 0000 01CF                 }
_0xB9:
; 0000 01D0             }
; 0000 01D1             else
	RJMP _0xC8
_0xB6:
; 0000 01D2             {
; 0000 01D3                 option++;
	LDI  R26,LOW(_option)
	LDI  R27,HIGH(_option)
	CALL SUBOPT_0x4
; 0000 01D4                 if (option > 6)
	CALL SUBOPT_0x15
	SBIW R26,7
	BRLO _0xC9
; 0000 01D5                     option = 0;
	CALL SUBOPT_0x6
; 0000 01D6                 show_led_counter = 0;
_0xC9:
	CALL SUBOPT_0x14
; 0000 01D7             }
_0xC8:
; 0000 01D8             delay_counter = -1;
	CALL SUBOPT_0x1C
; 0000 01D9         }
; 0000 01DA     }
_0xB2:
	RJMP _0xAF
; 0000 01DB }
_0xCA:
	RJMP _0xCA
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x1B,3
	RJMP _0x2000005
_0x2000004:
	CBI  0x1B,3
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x1B,4
	RJMP _0x2000007
_0x2000006:
	CBI  0x1B,4
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x1B,5
	RJMP _0x2000009
_0x2000008:
	CBI  0x1B,5
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x1B,6
	RJMP _0x200000B
_0x200000A:
	CBI  0x1B,6
_0x200000B:
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x2080002
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2080002
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2080003:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x1D
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x1D
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x2080002
_0x2000013:
_0x2000010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2080002
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x1A,3
	SBI  0x1A,4
	SBI  0x1A,5
	SBI  0x1A,6
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1E
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080002:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
; .FSTART _put_buff_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x4
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	CALL SUBOPT_0x4
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0x1F
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0x1F
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0x20
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x21
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0x20
	CALL SUBOPT_0x22
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0x20
	CALL SUBOPT_0x22
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0x20
	CALL SUBOPT_0x23
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x23
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0x1F
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0x1F
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x21
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0x1F
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x21
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x24
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080001
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x24
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_cache_position:
	.BYTE 0x8
_year:
	.BYTE 0x2
_option:
	.BYTE 0x2
_counter:
	.BYTE 0x2
_reset_counter:
	.BYTE 0x2
_delay_counter:
	.BYTE 0x2
_show_lcd_counter:
	.BYTE 0x2
_show_led_counter:
	.BYTE 0x2
_line_1:
	.BYTE 0x10
_line_2:
	.BYTE 0x10
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0x2:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	SBIW R30,1
	LDI  R26,LOW(_cache_position)
	LDI  R27,HIGH(_cache_position)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ADD  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	STS  98,R30
	LDI  R30,LOW(10)
	OUT  0x12,R30
	SBI  0x1B,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x4:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	STS  _reset_counter,R30
	STS  _reset_counter+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	STS  _option,R30
	STS  _option+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x9:
	ST   Y,R30
	STD  Y+1,R31
	LDS  R26,_show_led_counter
	LDS  R27,_show_led_counter+1
	SBIW R26,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	LDS  R26,_show_led_counter
	LDS  R27,_show_led_counter+1
	SBIW R26,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _show_led

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0xC:
	LDS  R26,_show_led_counter
	LDS  R27,_show_led_counter+1
	SBIW R26,20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
	LDS  R26,_show_led_counter
	LDS  R27,_show_led_counter+1
	SBIW R26,30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _show_led

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x11:
	LDS  R26,_show_led_counter
	LDS  R27,_show_led_counter+1
	SBIW R26,40
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _show_led

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	STS  _show_led_counter,R30
	STS  _show_led_counter+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
	LDS  R26,_option
	LDS  R27,_option+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _show_led

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _show_led

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x18:
	LDS  R26,_year
	LDS  R27,_year+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	LDS  R26,_year
	LDS  R27,_year+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	ST   -Y,R13
	ST   -Y,R12
	RCALL SUBOPT_0x19
	CALL _day_in_month_of_year
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(2020)
	LDI  R31,HIGH(2020)
	STS  _year,R30
	STS  _year+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	STS  _delay_counter,R30
	STS  _delay_counter+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1F:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x20:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x22:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
