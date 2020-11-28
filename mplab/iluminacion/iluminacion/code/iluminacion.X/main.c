/*
 * File:   newmain.c
 * Author: Dell
 *
 * Created on 5 de octubre de 2020, 10:11 AM
 */

/************ C R Y S T A L *************************************************/
//#define _XTAL_FREQ 20000000
#define _XTAL_FREQ 8000000
/************ I N C L U D E S *************************************************/
#include <pic16f887.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "configs.h"
#include <xc.h>
#include "usartlib.h"
#include "eepromlib.h"
#include "configtmrs.h"

/*********** P O R T    D E F I N I T I O N S  A N D   C O N S T A N T S **********************************/
#define RED           PORTCbits.RC0
#define TGG           PORTBbits.RB6
#define ECH           PORTBbits.RB7
#define RGB           255

/*********** L E D  S T A T U S  M E S S A G E ********************************/
char msj_tst_uart[]="Prueba lista\r";
char msj_cnf_param[]="Configuracion de parametros lista\r";
char msj_deploy[]="Deploy System...\r";
char msj_packet[35];

//Variables config
unsigned char cnt_Seg = 0;
unsigned int distance = 0;
unsigned int distance_to_ON = 0;
unsigned int time_ON = 0;
unsigned int centimeters = 0;

//Variables triple PWM  -   CARGAS
unsigned char cnt = 0;
unsigned char Qr = 0;
unsigned char Qg = 0;
unsigned char Qb = 0;
unsigned char Qt = 3;
unsigned char Qd = 100;
unsigned char cnt_Deathline = 0;
unsigned char i = 0;
unsigned char cuenta = 0;

unsigned char flag_rx = 0;
__bit START = 0;                 //bandera para el loop de start_Color

//Variables EEPROM
unsigned char lectura, escritura, direccion;

//variables
//char      8 bits
//int       16 bits
//long      24 bits
//float     32 bits
//double    64 bits

void PIC_Init(){
    ANSEL = 0;
    ANSELH = 0;
    TRISB = 0b10000000;         // RB7 In del sensor USonic, RB6 Out Trigger sUS, RB1 Out Visual Lamp, RB0 Out Visual Led 
    TRISC = 0b10000000;         // RC7 In RX, RC6 In TX, RC2 CCP1, RC1 CCP2, RC0 process_pulse
    PIE1 = 0b00110000;    
    PIR1 = 0b00000000;
    INTCON = 0b11000000;
    PORTB = 0;
    PORTC = 7;
    TRISD = 0;
    PORTD = 1;
    START = 1;
}

void MCU_Init(){
    OSCCONbits.SCS = 0;         // Fuente de reloj externo definido por CONFIG1{configs.h}
    PIC_Init();
}

void PWM_Init(){
    //(PR2+1)*4*(1/_XTAL_FREQ)*PRESC        El Postcaler no se considera para el PWM, solo el Prescaler
    //Fpwm = 255*4*(1/20,000,000)*4 = 0.000204
    TMR2_Cnf();
    //P1M1-0: PWM con una sola salida; DC1B1-0: a 0; CCP1M3-0: Pines P1A y P1C están activos a nivel alto, P1B,P1D activos abajo nivel.
    CCP1CON = 0b00001100;       // Configura el pin CCP1 Como PWM (0b00001100)
    CCPR1L = Qb;                // Ligada al ancho de pulso
    CCP2CON = 0b00001100;
    CCPR2L = Qg;
}   

//INTERRUPCION TMR0 PARA CONTABILIZAR SEGUNDOS EN QUE ESTÁ ENCENDIDA LA LÁMPARA
void __interrupt() pulsos(void){
    if(INTCONbits.TMR0IF){
        TMR0 = 0;
        cnt++;
        if(cnt == 75){                // TMR0 a su mínima temporización nos brinda 0.01310720 segundos, .:.
            //se debe acumular 75 veces, para 0.98304 de segundo ~ 1 seg.
            cnt = 0;
            cnt_Seg++;
            if(cnt_Seg == time_ON){   // Si ya se cumplieron los segundos que indicó el usuario, la bandera del loop se desactiva
                START=0;
            }
        }
        INTCON = 0b11100000;
    }else if(PIR1bits.RCIF){
        msj_packet[cuenta]=RCREG;   //lo almcena en el vector
        if ((cuenta>3) && (msj_packet[cuenta]=='z') && (msj_packet[cuenta-1]=='z') && (msj_packet[cuenta-2]=='z') ){
            flag_rx=1;//activa la bandera de que llego trama comple y ista para procesar
            CREN=0;
            //CREN_bit=0;  //DESHABILITA LA RECEPCION CONTINU PARA LIMPIAR BUFFER    Y NO RECIBIR MIENTRA VA A NALIZAR
            INTCONbits.GIE=0;  //deshabilita las interrpciones para poder procesar la trama
        }
        cuenta++;//incrementa contador o puntero del vectro de recibido
       //si es mayor que 30 debe limpiar la bandera y reiniciar el contador llego al maximo
        if (cuenta>=30){
            flag_rx=0;
            cuenta=0;
        }
        PIR1bits.RCIF=0; //limpia el bit de interrupcion        
    }
    //INTCON = 0b10100000;
}

/*METODO PARA CALCULAR LA DISTANCIA MEDIDA CON HC-SR04*/
void HCSR04_UpdateDistance(){  //COMPLETAMENTE FUNCIONAL
    distance = 0;
    TGG = 1;                            // Manda pulso por trigger
    __delay_us(10);                     // Espera 10us de acuerdo a la datasheet del sensor
    TGG = 0;                            // Pasa a flanco de bajada el trigger
    while(!ECH);                        // Mientras el pin echo está apagado
    while(ECH){                         // Detecta pin de subida
        distance++;                    // Incrementamos la distancia en centímetros 
        __delay_us(58);                 // Este valor por que en este tiempo equivale a 1cm de distancia
    }
    //la variable global distancia, ya posee el valor que se necesita
}

void loop(){
    while(START){                        // Inicia indefinida, pero el TMR0 la da de baja
        RED = 1;                        // Prende el pin RC0
        i=0;                            // Inicializa i;
        while(i<Qr){                    // itera para generar:- tiempo de pulso aprox (2.2us por cada U(i))
            i++;
        }
        RED = 0;                        // Apaga el pin RC0
        i=0;                            // Reinicia i;
        while(i<cnt_Deathline){         // itera para generar el tiempo restante del PWM
            i++;
        }
    }
}

void Color_Start(){
    PWM_Init();                         // Arranca ambos PWM a ~5 KHz
    loop();                             // Arranca el 3er PWM generado con acumulación de procesos, a ~5 KHz
}

/*METODO PARA ILUMINAR CUANDO SE ACTIVA EL SENSOR*/
void Test_ON(){  //COMPLETAMENTE FUNCIONAL
    if(distance <= distance_to_ON){       // Compara que distancia calculada sea menor o igual a la configurada
        TMR0_Init();                      // Inicia cronómetro de tiempo encendido
        Color_Start();
        TMR0_Stop();                     // Detiene ambos TMR's
        TMR2_Stop();
        cnt_Seg = 0;                     // Cuando se acaba el tiempo se resetea contador de segundos
        START = 1;                       // Para que entre en Loop, debe estar prendido, ya dentro de Loop gracias al TMR0 eventualmente se apagará
        PORTC = 7;                      // Los 3 pines prendidos, porque al ser de ánodo común (+), se apagan cuando reciben voltaje
    }
}

/*CONFIGURACION DE DISTANCIA DE ACTIVACION DE ILUMINACION*/
void CNF_Distance(unsigned int dist_ON){
    if(dist_ON > 0 && dist_ON <= 400){    // Hace validaciones del rango de distancia permitido
        distance_to_ON = dist_ON;           // Se asigna parámetro nuevo a la variable que guarda 
    }else{
        distance_to_ON = distance_to_ON;      // Se queda la configuración si la nueva se pasa de rango
    }
}

/*CONFIGURACION DE TIEMPO QUE ESTARA ILUMINANDO DESPUES DE ACTIVACION*/
void CNF_Time(unsigned int tiempo_ON){
    if(tiempo_ON > 0 && tiempo_ON <= 15){ // Hace validación del rango de tiempo parmitido
        time_ON = tiempo_ON;              // Se carga la nueva configuración a la variable que guardará esto
    }else{
        time_ON = time_ON;                // Si se pasa de rango quedará igual su configuración
    }
}

/*CONFIGURACION DE LOS PWM PARA QUE SE ENCIENDA DE UN COLOR PARAMETRIZADO*/
void CNF_Color(unsigned char R,unsigned char G,unsigned char B){
//Parámetros RBG puros los transforma a RGB inversos (para ánodo común .:. {RGB} prenden con tierra)
    Qr = RGB-R;
    Qg = RGB-G;
    Qb = RGB-B;
    Qr = Qr*90/RGB;
    cnt_Deathline = 90-Qr;//se obtiene el complemento de Qr {al ser un pulso generado por procesos, se necesita retener un proceso en alto y otro proceso en bajo}
}

void CNF_Print(){
    lectura = EEPROM_Read(50);
    sprintf(msj_packet, "i: %u, d: %u, t: %u, r: %u, g: %u, b: %u\r\n",lectura,Qd,Qt,Qr,Qg,Qb); // Envia todas las cargas en dist, tiem, rojo, verde, azul
    USART_SendText(msj_packet);
    __delay_ms(20);
}

/*HACE LOS CAMBIOS DE TODAS LAS NUEVAS CONFIGURACIONES*/
void CNF_Default(){  //COMPLETAMENTE FUNCIONAL
    //Las variables con Q, deben ser un input de datos del usuario
    /*****************/
    Qd = 150;//1.5 metros de detección
    CNF_Distance(Qd);
    /*****************/
    Qt = 5;//5 segundos
    CNF_Time(Qt);
    /***luz blanca***/
    Qr = 255;
    Qg = 0;
    Qb = 255;
    EEPROM_Save(127,Qd,Qt,Qr,Qg,Qb);//se guardan los parámetros RGB puros
    CNF_Color(Qr,Qg,Qb);//ya después se configuran (esta configuración lleva a cabo una manipulación de los valores)
}

/*HACE LOS CAMBIOS DE TODAS LAS NUEVAS CONFIGURACIONES*/
void CNF_Load(){  //COMPLETAMENTE FUNCIONAL
    //Las variables con Q, deben ser un input que previamente se guardó en EEPROM
    /*****************/
    Qd = EEPROM_Read(51);//150
    CNF_Distance(Qd);
    /*****************/
    Qt = EEPROM_Read(52);//5
    CNF_Time(Qt);
    /*****************/
    Qr = EEPROM_Read(53);//0
    Qg = EEPROM_Read(54);//0
    Qb = EEPROM_Read(55);//0
    //se extraen los valores RGB puros
    CNF_Color(Qr,Qg,Qb);//ya después se configuran (Q{r,g,b} se ajustan al tipo de tira led)
}

/*ESTE VERIFICARA SI SE REALIZARAN CAMBIOS O NO*/
void CNF_Params(){    //  Funciona, pero falta encontrarle una implementación
    if(USART_ReadChar() == '1'){        // Si el caracter leido es 1 si se realizara configuracion
        CNF_Default();                  // extrae de UART las configuraciones previas. -> extrae_UART():-Q{d,t,r,g,b}
        USART_SendText(msj_cnf_param);  // Retorna un mensaje informando que se han guardado las nuevas configuraciones
        __delay_ms(20);
    }
}

/*MAIN*/
void main(void){
    MCU_Init();
    USART_Init(_XTAL_FREQ, 9600);
    memset(msj_packet,0,35);
    __delay_ms(50);//Esperamos a que se estabilice todo
    
    USART_SendText("INICIANDO");
    //habilita int serial
    //PIR1bits.RCIF=0;
    //PIE1bits.RCIE=1;
    //INTCONbits.PEIE=1;
    //INTCONbits.GIE=1;

    lectura = EEPROM_Read(50);
    if(lectura == 127){ //si la EEPROM ya está configurada
        CNF_Load();
        //config_Color(255,(Qg-Qg),(RGB-Qb));//PARA VERIFICAR EL SAVE EN EEPROM
    }else{  //si no, se carga todo por defecto y se guardan esas CARGAS en EEPROM
        CNF_Default();
    }
    //config_Color(255,255,255);//Parámetros RGB puros
    //extrae de EEPROM las configuraciones previas. -> extrae_EEPROM():-Q{d,t,r,g,b}
    while(1){
        //configure_Params();                               // Está verificando si habra cambio de configuracion
        /*HCSR04_UpdateDistance();                          // Obtiene distancia detectada con obstruccion
        sprintf(msj_packet, "Distancia: %u\r\n",distancia); // Envia a qué distancia se detectó un objeto
        sendText_USART(msj_packet);                         // Mandamos un char
        evalua_ON();                                        // Evalua si prende la iluminacion
         */ 
        if(flag_rx == 1){
            memset(msj_packet,0,35);
            sprintf(msj_packet,"este es mi pinchi mensaje");
            cuenta=0;  //limpia el contador
            flag_rx=0; //limpia la bandera
            PIR1bits.RCIF=0; //limpia la bandera de interrpcion
            //CREN_bit=1;
            CREN = 1;
            INTCONbits.GIE=1;
            USART_SendText(msj_packet);
            Color_Start();
        }
            /*sprintf(msj_packet,"este es mi pinchi mensaje");
            USART_SendText(msj_packet);
            __delay_ms(50);*/
    }
    return;
}