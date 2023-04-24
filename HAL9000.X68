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
CODE:   DS.W 16    
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
    MOVE.W  EMEM(D0),EIR
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
    MOVE.W  (SP)+,CODE(A0)
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
ELOA:
ESTO:
ELOIP:
ESTIP:
EGOI:
EGOZ:
EGON:
EEXIT:
ECOPY:
EADD:
ESUB:
EAND:
ESET:
EADQ:
ELSH:
    ;--- FEXEC: FIN EJECUCION
    
    

    ;--- ISUBR: INICIO SUBRUTINAS
        ;*** Aqui debeis incluir las subrutinas que necesite vuestra solucion
        ;*** SALVO DECOD, que va en la siguiente seccion

	        ; ESCRIBID VUESTRO CODIGO AQUI
        
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
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
