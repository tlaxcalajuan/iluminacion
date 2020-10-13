/*
 * File:   newmain.c
 * Author: tlaxcala
 *
 * Created on 5 de octubre de 2020, 10:11 AM
 */
#include <xc.h>
#include "configs.h"

//libraries
#include "USARTlib.h"

//cristal
#define _XTAL_FREQ 16000000

//definir nombres a mis puertos a utilizar
#define Echo RB7;
#define Trigger RB6;
//variables config
unsigned long cnt=0;
unsigned int cntSeg=0;

//banderas
char tmrStatus;

//variables
//unsigned int tiempo;
unsigned int distancia;

unsigned int distanciaON;
unsigned int timeON;

/*ARRANCA TIMER*/
void initTMR0(){
  OPTION_REG = 0x82;
  TMR0  = 6;
  INTCON = 0xA0;
}

/*INTERRUPCION PARA TMR0*/
void __interrupt() inter(void){
    if(TMR0IF){                         // bandera de desborde al tiempo asignado en su config
        cnt++;                          // incrementa contador cada interrupcion
        TMR0IF = 0;                     // se apaga bandera desborde
        TMR0 = 6;                       // cargamos valor nuevamente en tmr0
        if(cnt == 2000){                // Aproximación a 1.03 segundos(con 8mhz seria 1000 la igualacion))
            cnt = 0;                    // contador se resetea a 0
            cntSeg++;                   // aqui se incrementa el contador a cada segundo
        } 
    }
}


/*METODO PARA CALCULAR LA DISTANCIA MEDIDA CON HC-SR04*/
unsigned int HCSR04_GetDistance(void){
    unsigned int centimeters=0;
    RB6 = 1;                            // manda pulso por trigger
    __delay_us(10);                     // espera 10us de acuredo a la datasheet del sensor
    RB6 = 0;                            // pasa aflanco de bajada el trigger
    RB0=0;
    while(!RB7);                        // mientras el pin echo esta apagado
    
    while(RB7){                         // detecta pin de subida
        centimeters++;                  // increementamos la distancia en centimetros 
        __delay_us(58);                 // este valor por que en este tiempo equivale a 1cm de distancia
        RB0=1;                          // se prende led de que se encuentra sensando
    }
    RB0=0;                              // apagamos led de sensado
    return(centimeters);                // retorna distancia calculada en la variable centimetros
}

/*METODO PARA ILUMINAR CUANDO SE ACTIVA EL SENSOR*/
void prende(){
    //distanciaON=150;
    //timeON=5;
    if(distancia<=distanciaON){         // compara que distancia calculada sea menor o igual a la configurada
        initTMR0();                     // inicia cronometro de tiempo encendido
        while(cntSeg<=timeON){          // mientras el contador de interrupcion sea menor a el tiempo asignado encendido
            RB1=1;                      // se enciende la isluminacion
        }
        cntSeg=0;                       // cuando se acaba el tiempo se resetea contador de segundos
        T0IE=0;                         // desabilitamos t0ie
    }else{
        RB1=0;                          // apagamos iluminacion
    }
    RB1=0;                              // apagamos iluminacion
}

/*PRUEBAS DE COMUNIACION UART*/         // ...pruebas
void calandoUART(){
    start_usart();                      // iniciamos comunicacion uart a 9600 baudios
    SendChar_usart('a');                // mandamos un char
    __delay_ms(500);                    // esperamos 500 milis
    SendText_usart("dfff");             // mandamos un texto 
}

/*CONFIGURACION DE DISTANCIA DE ACTIVACION DE ILUMINACION*/
void configDistance(unsigned int distON){
    if(distON>0&&distON<=400){          // hace validaciones del rango de distancia permitido
        distanciaON=distON;             // se asigna parametro nuevo a la variable que guarda 
    }else{
        distanciaON=distanciaON;        // se queda la configuracion si la nueva se pasa de rango
    }
}

/*CONFIGURACION DE TIEMPO QUE ESTARA ILUMINANDO DESPUES DE ACTIVACION*/
void configTime(unsigned int tiempoON){
    if(tiempoON>0&&tiempoON<=15){       // hace validacion del rango de tiempo parmitido
        timeON=tiempoON;                // se carga la nueva configuracion a la variable que guardara esto
    }else{
        timeON=timeON;                  // si se pasa de rango quedara igual su configuracion
    }
}

/*CONFIGURACION DEL COLOR A ILUMINAR*/
void configColor(unsigned char R, unsigned char G, unsigned char B){
    if((R+G+B)<765){                    // compara si la suma de los tres colores es menor al maximo de todos
        // aqui debe cargar los colores nuevos a el led
    }
}

/*HACE LOS CAMBIOS DE TODAS LAS NUEVAS CONFIGURACIONES*/
void changeConfigs(){
    configDistance(150);                // llama el metodo respectivo de cada configuracion: distancia new
    configTime(5);                      // : tiempoON new
    configColor(255,165,0);             // : color new
}

/*ESTE VERIFICARA SI SE REALIZARAN CAMBIOS O NO*/
void Configure(){
    if(ReadChar_usart()=='1'){          // si el caracter leido es 1 si se realizara configuracion
        changeConfigs();                // llama metodo que actualizara valores de config
        SendText_usart("save configs"); // retorna un mensaje informando que se han guardado las nuevas configuraciones
    }
}

/*MAIN*/
void main(void) {
    ANSEL=0;
    ANSELH=0;
    TRISB6=0;
    TRISB7=1;
    TRISB1=0;
    TRISB0=0;
    TRISB3=0;
    TRISC7=1;
    TRISC6=0;
    PIE1=0b00110000;
    
    while(1){
        Configure();                    // esta verificando si habra cambio de configuracion
        distancia=HCSR04_GetDistance(); // obtiene distancia detectada con obstruccion
        RB1=0;                          // ...pruebas
        prende();                       // prende la iluminacion   
        RB3=0;                          // ...pruebas
        calandoUART();                  // ...probando comunicacion
    }
    return;
}
