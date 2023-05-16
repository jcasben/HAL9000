# HAL9000
Práctica final de la asignatura Estructura de Computadores I, donde se realizará un emulador de una procesador teórico llamado HAL9000.

La máquina que se debe emular en esta práctica se llama HAL9000 (Heuristically Programmed Algorithmic Computer). Tanto los registros como su conjunto de
instrucciones son de 16 bits. La HAL9000 posee los siguientes registros:


- T0 y T1, que se utilizan como interfaz con la memoria, adem´as de poder ser empleados en algunas operaciones de tipo ALU como operando.

- X2, X3, X4, X5, X6 y X7, que son de propósito general y se utilizan fundamentalmente en operaciones de tipo ALU, ya sea como operando fuente o como operando destino.

La tabla que se muestra a continuación contiene las instrucciones del procesador, junto con su codificación, la operación que realiza en el lenguaje de
transferencia entre registros y los flags que actualiza la instrucción. Debajo de esta tabla, se encuentra una leyenda que explica cada uno de los símbolos e
indicaciones que se encuentran en la tabla.

![image](https://github.com/jcasben/HAL9000/assets/105555875/db4b7a24-806d-4970-8a6b-369d864c194e)


Para emular el funcioanmiento de este procesador era necesario programar una fase de Fetch, donde se recogiera la siguiente instrucción que se tuviera que realizar,
una fase de decodificación (en este caso, esta fase de decodificación está implementada con una subrutina de librería, que puede ser utilizada en cualquier otro programa del Motorola 68000) y una fase de ejecución, en la que se programará el comportamiento de cada instrucción. 
