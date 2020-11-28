#include <pic16f887.h>
#include "usartlib.h"

///////////////////////////////////////////////
//inicialización del módulo USART PIC modo asíncrono
//en una función, a 8bits,a 9600 baudios
/////////////////////////////////////////////////////
unsigned int BAUDIOS = 0;

void USART_Init(const long int XTAL, long int baudrate){/*unsigned long fosc,unsigned int bauds*/
    BAUDIOS = (XTAL - baudrate*16)/(baudrate*16);
    //unsigned char calcBauds = ((unsigned char)fosc/(16*bauds)-1);
     UART_RX_TRIS = 1;          // pin RX como una entrada digital
     UART_TX_TRIS = 0;          // pin TX como una salida digital
     UART_TX_REG = 0;           // Reset TXSTA
     UART_RX_REG = 0;           // Reset RCSTA
     UART_TX_REG = 0b00100110;  // SyncMode:Slave, 8bits, transmisión habilitada, asíncrono, alta velocidad, TRMT Empty
     UART_RX_REG = 0b10010000;  // habilita SERIAL Port, recepción 8 bits, asíncrono, recepción continua habilitada, no importa para 8 bits, No framing error, No Overrun error
     SPBRG = BAUDIOS;           // para una velocidad de 9600baudios con un oscilador de 16Mhz (103)
     //INTCON=0b11000000;
}
 
///////////////////////////////////////////////
//recepción de datos del módulo USART PIC modo asíncrono
////////////////////////////////////////////////////////////
unsigned char USART_ReadChar(void){
    unsigned char rcv_data;
    //while(!PIR1bits.RCIF);//si el bit5 del registro PIR1 se ha puesto a 1
    if(PIR1bits.RCIF){
        rcv_data = RCREG;
        PIR1bits.RCIF = 0;
        return rcv_data;
    }else{
        return 'z';
    }
}

//char * USART_ReadText(){
//    char* recv_data[15];
//    unsigned char i = 0;
//    unsigned char j = 0;
//    recv_data[0] = USART_ReadChar();
//    while(recv_data[j]!='z'){//0 -> 1
//        recv_data[i++] = USART_ReadChar();//1-1 = 0 -> 1
//        if(i>1){
//            j++;
//        }
//    }
//    return recv_data;
//}
 
///////////////////////////////////////////////
//transmisión de datos del módulo USART PIC modo asíncrono
///////////////////////////////////////////////
void USART_SendChar(char caracter){
    TXREG = caracter;//cuando el el registro TRMT/TSR está vacio se envia el caracter
    while(TRMT == 0);// mientras el registro TRMT/TSR esté lleno espera
}
 
 
///////////////////////////////////////////////
//transmisión de cadenas de caracteres con el módulo USART PIC modo asíncrono
///////////////////////////////////////////////
void USART_SendText(char *cadena){//cadena de caracteres de tipo char
    while(*cadena != '\0'){//mientras el último valor de la cadena sea diferente
                          //de el caracter nulo
        USART_SendChar(*cadena);//transmite los caracteres de cadena
        cadena++;//incrementa la ubicación de los caracteres en cadena
                 //para enviar el siguiente caracter de cadena
    }
}