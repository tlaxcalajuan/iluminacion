////////////////////////////////////////////////////////////////////
//Archivo de cabecera para el uso del m�dulo USART PIC con el XC8///
///////////////////////////////////////////////////////////////////
 
#ifndef USARTLIB_H
#define	USARTLIB_H

#ifdef	__cplusplus
extern "C" {
#endif
/****PORT D E F I N I T I O N S ***********************************************/
    //UART PORT DEFINITIONS
    #define UART_RX_TRIS    TRISCbits.TRISC7
    #define UART_TX_TRIS    TRISCbits.TRISC6
    #define UART_RX_REG	RCSTA
    #define UART_TX_REG	TXSTA
    
/********* G E N E R I C   D E F I N I T I O N S ******************************/
    #define BAUD_CONTROL		00
    #define BAUD_RATE           25
    
/*********** P R O T O T Y P E S **********************************************/
    void USART_Init(const long int XTAL, long int baudrate);//funci�n para iniciar el USART PIC as�ncron, 8 bits, 9600 baudios
    unsigned char USART_ReadChar(void);//funci�n para la recepci�n de caracteres
    char * USART_ReadText(void);
    void USART_SendChar(char caracter);//funci�n para la transmisi�n de caracteres
    void USART_SendText(char *cadena);//funci�n para la transmisi�n de cadenas de caracteres
#ifdef	__cplusplus
}
#endif
 
#endif	/* UART_H */