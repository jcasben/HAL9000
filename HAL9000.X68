*-----------------------------------------------------------
* Title      : PRAFIN23
* Written by : MARC LINK CLADERA y JESÚS CASTILLO BENITO
* Date       : 19/05/2023
* Description: Emulador de la HAL9000
*-----------------------------------------------------------
    ORG $1000
EMEM:   DC.W $E082,$E09B,$E0B4,$E01D,$2020,$C006,$2031,$C017,$F160
        DC.W $F170,$CE70,$3040,$EFFD,$501E,$4008,$8000,$0001
        DC.W $0001,$0001,$0001,$0001,$0001,$0000,$0000,$0000
EIR:    DC.W 0 ;eregistro de instruccion
EPC:    DC.W 0 ;econtador de programa
ET0:    DC.W 0 ;eregistro T0
ET1:    DC.W 0 ;eregistro T1
EX2:    DC.W 0 ;eregistro X2
EX3:    DC.W 0 ;eregistro X3
EX4:    DC.W 0 ;eregistro X4
EX5:    DC.W 0 ;eregistro X5
EX6:    DC.W 0 ;eregistro X6
EX7:    DC.W 0 ;eregistro X7
ESR:    DC.W 0 ;eregistro de estado (00000000 00000CNZ)

START:
    CLR.W   EPC
    MOVE.W  #0,EPC

FETCH:
    ;--- IFETCH: INICIO FETCH
        ;*** En esta seccion debeis introducir el codigo necesario para cargar
        ;*** en el EIR la siguiente instruccion a ejecutar, indicada por el EPC,
	    ;*** y dejar listo el EPC para que apunte a la siguiente instruccion
	
	        ; ESCRIBID VUESTRO CODIGO AQUI
	MOVE.W  EPC,D0
	MULU.W  #2,D0
	MOVE.W  D0,A0
    MOVE.W  EMEM(A0),EIR
    ADDQ.W  #1,EPC	    
        
    ;--- FFETCH: FIN FETCH
    
    
    ;--- IBRDECOD: INICIO SALTO A DECOD
        ;*** En esta seccion debeis preparar la pila para llamar a la subrutina
        ;*** DECOD, llamar a la subrutina, y vaciar la pila correctamente,
        ;*** almacenando el resultado de la decodificacion en D1

    	    ; ESCRIBID VUESTRO CODIGO AQUI
    SUBQ.W  #2,SP
    MOVE.W  EIR,-(SP)
    JSR     DECOD
    ADDQ.W  #2,SP
    MOVE.L  #0,A0
    MOVE.W  (SP)+,D1
    ADDQ.L  #2,A0 	    
        
    ;--- FBRDECOD: FIN SALTO A DECOD
    
    
    
    ;--- IBREXEC: INICIO SALTO A FASE DE EJECUCION
        ;*** Esta seccion se usa para saltar a la fase de ejecucion
        ;*** NO HACE FALTA MODIFICARLA
    MULU #6,D1
    MOVEA.L D1,A1
    JMP JMPLIST(A1)
JMPLIST:
    JMP ELOA
    JMP ESTO
    JMP ELOIP
    JMP ESTIP
    JMP EGOI
    JMP EGOZ
    JMP EGON
    JMP EEXIT
    JMP ECOPY
    JMP EADD
    JMP ESUB
    JMP EAND
    JMP ESET
    JMP EADQ
    JMP ELSH
    ;--- FBREXEC: FIN SALTO A FASE DE EJECUCION
    
    
    
    ;--- IEXEC: INICIO EJECUCION
        ;*** En esta seccion debeis implementar la ejecucion de cada einstr.
	
	; ESCRIBID EN CADA ETIQUETA LA FASE DE EJECUCION DE CADA INSTRUCCION
ELOA:   ; ****** ELOA: COMIENZO DE ELOA ***************************************

        MOVE.W  EIR,D0  ;0000xxxmmmmmmmmi
        MOVE.W  EIR,D1   
        AND.W   #%0000000111111110,D0
        LSR.L   #1,D0
        MOVE.W  D0,A1
        BTST    #0,D1
        BNE     TO_T1LOA
        
        MOVE.W  EMEM(A1),ET0
        BRA     FETCH
TO_T1LOA: 
        MOVE.W  EMEM(A1),ET1
        BRA     FETCH 
        
        ; falta actualizar flags ----------------------------------------------
        ; ****** ELOA: FINAL DE ELOA ******************************************
        
        
ESTO:   ; ****** ESTO: COMIENZO DE ESTO ***************************************

        MOVE.W  EIR,D0  ;0001xxxmmmmmmmmi
        MOVE.W  EIR,D1   
        AND.W   #%0000000111111110,D0
        LSR.L   #1,D0
        MOVE.W  D0,A1
        BTST    #0,D1
        BNE     TO_T1STO
        
        MOVE.W  (ET0),EMEM(A1)
        BRA     FETCH
TO_T1STO:
        MOVE.W  (ET1),EMEM(A1)
        BRA     FETCH
        
        ; ****** ESTO: FINAL DE ESTO ******************************************
        
        
ELOIP:  ; ****** ELOIP: COMIENZO DE ELOIP *************************************

        MOVE.W  EIR,D0
        MOVE.W  EIR,D1
        AND.W   #%0000000001110000,D0
        LSR.L   #4,D0
        MOVE.W  D0,D7
        JSR     DECODE_RX
        MOVEA.L (A6),A5 ; contenido del registro Rb
        MOVE.L  A5,D3   ; contenido del contenido del registro Rb
        ; post-incremento del contenido del registro Rb
        ADDA.L  #2,A5
        MOVE.W  A5,(A6)
  
        BTST    #0,D1
        BNE     TO_T1LOIP
        
        MOVE.W  D3,ET0
        BRA     FETCH
        
TO_T1LOIP:
        MOVE.W  D3,ET1
        BRA     FETCH
        
        ; falta actualizar flags ----------------------------------------------
        ; ****** ELOIP: FINAL DE ELOIP ****************************************
        
        
ESTIP:  ; ****** ESTIP: COMIENZO DE ESTIP *************************************

        MOVE.W  EIR,D0
        MOVE.W  EIR,D1
        AND.W   #%0000000001110000,D0
        LSR.L   #4,D0
        MOVE.W  D0,D7
        JSR     DECODE_RX
        MOVE.L  (A6),A5 ;contenido del registro Rb
        ; post-incremento del contenido del registro Rb
        
        BTST    #0,D1
        BNE     TO_T1ESTIP
        
        MOVE.W  ET1,A5
        ADDA.L  #2,A5
        MOVE.W  A5,(A6)
        BRA     FETCH

TO_T1ESTIP:
        MOVE.W  ET1,A5
        ; post-incremento del contenido de Xb
        ADDA.L  #2,A5
        MOVE.W  A5,(A6)
        BRA     FETCH
        
        ; ****** ESTIP: FINAL DE ESTIP ****************************************


EGOI:   ; ****** EGOI: COMIENZO DE EGOI ***************************************

        MOVE.W  EIR,D0  ;0001xxxmmmmmmmmx  
        AND.W   #%0000000111111110,D0
        LSR.L   #1,D0
        MOVE.W  D0,EPC
        BRA     FETCH
        
        ; ****** EGOI: FINAL DE EGOI ******************************************


EGOZ:   ; ****** EGOZ: COMIENZO DE EGOZ ***************************************

        MOVE.W  EIR,D0  ;0001xxxmmmmmmmmx  
        AND.W   #%0000000111111110,D0
        LSR.L   #1,D0
        BTST    #0,ESR
        BNE     TO_GOZ
        BRA     FETCH
        
TO_GOZ:
        MOVE.W  D0,EPC
        BRA     FETCH
        
        ; ****** EGOZ: FINAL DE EGOZ ******************************************


EGON:   ; ****** EGON: COMIENZO DE EGON ***************************************

        MOVE.W  EIR,D0  ;0001xxxmmmmmmmmx  
        AND.W   #%0000000111111110,D0
        LSR.L   #1,D0
        BTST    #1,ESR
        BNE     TO_GON
        BRA     FETCH
        
TO_GON:
        MOVE.W  D0,EPC
        BRA     FETCH
        
        ; ****** EGON: FINAL DE EGON ****************************************** 

 
EEXIT:  ; ****** EXIT: COMIENZO DE EEXIT **************************************

        SIMHALT         ; halt simulator
        
        ; ****** EEXIT: FINAL DE EEXIT ****************************************


ECOPY:  ; ****** ECOPY: COMIENZO DE ECOPY *************************************

        MOVE.W  EIR,D0
        MOVE.W  EIR,D1
        AND.W   #%0000000001110000,D0
        LSR.L   #4,D0
        MOVE.W  D0,D7
        JSR     DECODE_RX
        MOVEA.W A6,A0 ;exraemos Rb
        AND.W   #%0000000000000111,D1
        MOVE    D1,D7 
        JSR     DECODE_RX
        MOVEA.W A6,A1 ; extraemos Rc
        ; A0 = RB
        ; A1 = RC
        ; RC <-- [RB]
        MOVE.W  (A0),(A1)
        
        BRA     FETCH
        
        ; ****** ECOPY: FINAL DE ECOPY **************************************** 
        
 
EADD:   ; ****** EADD: COMIENZO DE EADD ***************************************

        MOVE.W  EIR,D0
        MOVE.W  EIR,D1
        MOVE.W  EIR,D3
        AND.W   #%0000000001110000,D0
        LSR.L   #4,D0
        MOVE.W  D0,D7
        JSR     DECODE_RX
        MOVEA.W A6,A0 ; extraemos Rb
        AND.W   #%0000000000000111,D1
        MOVE    D1,D7 
        JSR     DECODE_RX
        MOVEA.W A6,A1 : extraemos Rc
        AND.W   #%0000011100000000,D3
        LSR.L   #8,D3
        MOVE.W  D3,D7 
        JSR     DECODE_RX
        MOVEA.L A6,A2 ; extraemos Ra
        
        ; hacemos la suma:
        MOVE    (A0),D4
        ADD.W   (A2),D4
        MOVE.W  D4,(A1)
        
        BRA     FETCH
        
        ; ****** EADD: FINAL DE EADD ******************************************
        
        
ESUB:   ; ****** ESUB: COMIENZO DE ESUB ***************************************

        MOVE.W  EIR,D0
        MOVE.W  EIR,D1
        MOVE.W  EIR,D3
        AND.W   #%0000000001110000,D0
        LSR.L   #4,D0
        MOVE.W  D0,D7
        JSR     DECODE_RX
        MOVEA.W A6,A0 ; extraemos Rb
        AND.W   #%0000000000000111,D1
        MOVE    D1,D7 
        JSR     DECODE_RX
        MOVEA.W A6,A1 : extraemos Rc
        AND.W   #%0000011100000000,D3
        LSR.L   #8,D3
        MOVE.W  D3,D7 
        JSR     DECODE_RX
        MOVEA.L A6,A2 ; extraemos Ra
        
        ; hacemos la resta:
        ; A0 = RB
        ; A2 = RA
        MOVE.W  (A2),D4
        SUB.W   (A0),D4
        MOVE.W  D4,(A1)
        
        BRA     FETCH
        
        ; ****** ESUB: FINAL DE ESUB ******************************************
        
        
EAND:   ; ****** EAND: COMIENZO DE EAND ***************************************

        MOVE.W  EIR,D0
        MOVE.W  EIR,D1
        MOVE.W  EIR,D3
        AND.W   #%0000000001110000,D0
        LSR.L   #4,D0
        MOVE.W  D0,D7
        JSR     DECODE_RX
        MOVEA.W A6,A0 ; extraemos Rb
        AND.W   #%0000000000000111,D1
        MOVE    D1,D7 
        JSR     DECODE_RX
        MOVEA.W A6,A1 : extraemos Rc
        AND.W   #%0000011100000000,D3
        LSR.L   #8,D3
        MOVE.W  D3,D7 
        JSR     DECODE_RX
        MOVEA.L A6,A2 ; extraemos Ra
        
        ; hacemos la AND:
        ; A0 = RB
        ; A2 = RA
        
        MOVE.W  (A2),D4
        AND.W   (A0),D4
        MOVE.W  D4,(A1)
        
        BRA     FETCH
        
        ; ****** EAND: FINAL DE EAND ******************************************
        
        
ESET:   ; ****** ESET: COMIENZO DE ESET ***************************************

        MOVE.W  EIR,D0
        MOVE.W  EIR,D1
        AND.W   #%0000011111111000,D0
        LSR.L   #3,D0
        EXT.W   D0
        AND.W   #%0000000000000111,D1
        MOVE    D1,D7 
        JSR     DECODE_RX
        MOVEA.W A6,A1 : extraemos Rc
        MOVE.W  D0,(A1)
        
        BRA     FETCH

        ; ****** ESET: FINAL DE ESET ******************************************
        
        
EADQ:   ; ****** EADQ: COMIENZO DE EADQ ***************************************

        MOVE.W  EIR,D0
        MOVE.W  EIR,D1
        AND.W   #%0000011111111000,D0
        LSR.L   #3,D0
        EXT.W   D0
        AND.W   #%0000000000000111,D1
        MOVE    D1,D7 
        JSR     DECODE_RX
        MOVEA.W A6,A1 : extraemos Rc
        ADD.W   D0,(A1)
        
        BRA FETCH

        ; ****** EADQ: FINAL DE EADQ ******************************************


ELSH:   ; ****** ELSH: COMIENZO DE ELSH ***************************************

        MOVE    EIR,D0
        MOVE    EIR,D1
        MOVE    EIR,D2
        AND.W   #%0000000001110000,D0
        LSR.L   #4,D0
        MOVE.W  D0,D7
        JSR     DECODE_RX
        MOVEA.W A6,A0 ; extraemos Rb
        AND.W   #%0000011100000000,D1
        LSR.L   #8,D1 ;p

        BTST    #0,D2
        BNE     RSHIFT
        
        MOVE.W  (A0),D3
        LSL.L   D1,D3
        MOVE    D3,(A0) ; ******mirar si es A0 o (A0)
        
        BRA     FETCH
RSHIFT:
        MOVE.W  (A0),D3
        LSR.L   D1,D3
        MOVE    D3,(A0) 

        BRA     FETCH
        
        ; ****** ELSH: ELSH DE ELSH *******************************************
        
        
    ;--- FEXEC: FIN EJECUCION
    
    

    ;--- ISUBR: INICIO SUBRUTINAS
        ;*** Aqui debeis incluir las subrutinas que necesite vuestra solucion
        ;*** SALVO DECOD, que va en la siguiente seccion

	        ; ESCRIBID VUESTRO CODIGO AQUI
DECODE_RX:
        ; Decodificación para saber el Rx sobre el cual
        ; se hará la operación. Pasamos por parametro 
        ; el valor de los tres bits que nos indicara
        ; el numero del registro mediante el D7. Posteriormente
        ; la subrutina devuelve la dirección del registro mediante
        ; el registro A6.
        BTST    #2,D7
        BNE     FROM_4
        ;tenemoos 0xx
        BTST    #1,D7
        BNE     FROM_2
        ;tenemos 00x
        BTST    #0,D7
        BNE     FROM_1
        ;tenemos 000
        LEA.L   ET0,A6
        RTS   
        
        
FROM_1:
        LEA.L   ET1,A6
        RTS
        
FROM_2:       
        BTST    #0,D7
        BNE     FROM_3
        LEA.L   EX2,A6
        RTS 
FROM_3:
        LEA.L   EX3,A6
        RTS
        
FROM_4:
        BTST    #1,D7
        BNE     FROM_6
        BTST    #0,D7
        BNE     FROM_5
        
        LEA.L   EX4,A6
        RTS
        
FROM_5:
        LEA.L   EX5,A6
        RTS
        
FROM_6:
        BTST    #0,D7
        BNE     FROM_7
        LEA.L   EX6,A6
        RTS

FROM_7:
        LEA.L   EX7,A6
        RTS
        
    ;--- FSUBR: FIN SUBRUTINAS
    
    

    ;--- IDECOD: INICIO DECOD
        ;*** Tras la etiqueta DECOD, debeis implementar la subrutina de 
        ;*** decodificacion, que debera ser de libreria, siguiendo la interfaz
        ;*** especificada en el enunciado
DECOD:
    MOVE.L  D1,-(SP)
    MOVE.W  8(SP),D1

    BTST    #15,D1
    BNE     TO_SEVEN
    BTST    #14,D1      ; tenemos 0X
    BNE     TO_FOUR
    BTST    #13,D1      ; tenemos 00X
    BNE     TO_TWO
    BTST    #12,D1      ; tenemos 000
    BNE     TO_ONE
    MOVE.W    #0,10(SP)
    BRA     TO_END
    
TO_ONE:                 ; tenemos 0001
    MOVE.W  #1,10(SP)
    BRA     TO_END
    
TO_TWO:                 ; tenemos 001X
    BTST    #12,D1
    BNE     TO_THREE
    MOVE.W  #2,10(SP)
    BRA     TO_END
    
TO_THREE:               ; tenemos 0011
    MOVE.W  #3,10(SP)
    BRA     TO_END
    
TO_FOUR:                ; tenemios 01XX
    BTST    #13,D1
    BNE     TO_SIX
    ; tenemos 010X
    BTST    #12,D1
    BNE     TO_FIVE
    MOVE.W  #4,10(SP)    ; tenemos 0100
    BRA     TO_END
    
TO_FIVE:                ; tenemos 0101
    MOVE.W  #5,10(SP)
    BRA     TO_END
    
TO_SIX:                 ; tenemos 011X. Como sabemos que no exixte la instrucción 0111, 
                        ; podemos asegurar que estamos ante la instrucción 0110
    MOVE.W  #6,10(SP)
    BRA     TO_END

TO_SEVEN:               ; tenemos 1
    BTST    #14,D1
    BNE     TO_EIGHT
    MOVE.W  #7,10(SP)
    BRA     TO_END

TO_EIGHT:               ; tenemos 11XXX   
    BTST    #13,D1
    BNE     TO_TWELVE
    ; tenemos 110XX
    BTST    #12,D1
    BNE     TO_TEN
    ; tenemos 1100X
    BTST    #11,D1
    BNE     TO_NINE
    MOVE.W  #8,10(SP)
    BRA     TO_END
    
TO_NINE:                ; tenemos 11001
    MOVE.W  #9,10(SP)
    BRA     TO_END       

TO_TEN:                 ; tenemos 1101X
    BTST    #11,D1
    BNE     TO_ELEVEN
    MOVE.W  #10,10(SP)
    BRA     TO_END
    
TO_ELEVEN:              ; tenemos 11011
    MOVE.W  #11,10(SP)
    BRA     TO_END
    
TO_TWELVE:              ; tenemos 111XX
    BTST    #12,D1
    BNE     TO_FOURTEEN
    ; tenemos 1110X
    BTST    #11,D1
    BNE     TO_THIRTEEN
    ; tenemos 11100
    MOVE.W  #12,10(SP)
    BRA     TO_END
    
TO_THIRTEEN:            ; tenemos 11101
    MOVE.W  #13,10(SP)
    BRA     TO_END
    
TO_FOURTEEN:            ; tenemos 11110
    MOVE.W  #14,10(SP)
    
TO_END:
    
    MOVE.L (SP)+,D1
    RTS  
	        ; ESCRIBID VUESTRO CODIGO AQUI

    ;--- FDECOD: FIN DECOD
    END    START








*~Font name~Courier New~
*~Font size~14~
*~Tab type~1~
*~Tab size~4~
