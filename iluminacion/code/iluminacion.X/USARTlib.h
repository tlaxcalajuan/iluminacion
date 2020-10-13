////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
//Archivo de cabecera para el uso del m�dulo USART PIC con el XC8///
///////////////////////////////////////////////////////////////////
 
#ifndef USART_H
#define	USART_H

#include <stdlib.h>
 
void start_usart();//funci�n para iniciar el USART PIC as�ncron, 8 bits, 9600 baudios
unsigned char ReadChar_usart();//funci�n para la recepci�n de caracteres
void SendChar_usart(unsigned char);//funci�n para la transmisi�n de caracteres
void SendText_usart(char*);//funci�n para la transmisi�n de cadenas de caracteres
 
///////////////////////////////////////////////
//inicializaci�n del m�dulo USART PIC modo as�ncrono
//en una funci�n, a 8bits,a 9600 baudios
/////////////////////////////////////////////////////
void start_usart(/*unsigned long fosc,unsigned int bauds*/){
     //unsigned char calcBauds = ((unsigned char)fosc/(16*bauds)-1);
     TRISC7=1;//pin RX como una entrada digital
     TRISC6=0;//pin TX como una salida digital
     TXSTA=0b00100110;// 8bits, transmisi�n habilitada, as�ncrono, alta velocidad
     RCSTA=0b10010000;//habilitado el USART PIC, recepci�n 8 bits,  habilitada, as�ncrono
     SPBRG=103;//para una velocidad de 9600baudios con un oscilador de 16Mhz
     INTCON=0b11000000;
    }
 
///////////////////////////////////////////////
//recepci�n de datos del m�dulo USART PIC modo as�ncrono
////////////////////////////////////////////////////////////
unsigned char ReadChar_usart(){
    if(RCIF==1){//si el bit5 del registro PIR1 se ha puesto a 1
    return RCREG;//devuelve el dato almacenado en el registro RCREG
    }
    //else//sino
        return 0;//retorna sin hacer nada
}
 
///////////////////////////////////////////////
//transmisi�n de datos del m�dulo USART PIC modo as�ncrono
///////////////////////////////////////////////
void SendChar_usart(unsigned char caracter){
    while(TRMT==0);// mientras el registro TSR est� lleno espera
	TXREG = caracter;//cuando el el registro TSR est� vacio se envia el caracter
}
 
 
///////////////////////////////////////////////
//transmisi�n de cadenas de caracteres con el m�dulo USART PIC modo as�ncrono
///////////////////////////////////////////////
void SendText_usart(char* cadena){//cadena de caracteres de tipo char
    while(*cadena !=0x00){//mientras el �ltimo valor de la cadena sea diferente
                          //de el caracter nulo
        SendChar_usart(*cadena);//transmite los caracteres de cadena
        cadena++;//incrementa la ubicaci�n de los caracteres en cadena
                 //para enviar el siguiente caracter de cadena
    }
}
 
#endif	/* USART_H */