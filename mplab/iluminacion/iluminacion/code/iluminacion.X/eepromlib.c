/*
 * File:   eeprom.c
 * Author: Dell
 *
 * Created on 21 de noviembre de 2020, 10:53 AM
 */
#include <pic16f887.h>
#include <pic.h>
#include "eepromlib.h"
#define _XTAL_FREQ 20000000

unsigned char dato = 0;

unsigned char EEPROM_Read(unsigned char address){
    EEADR = address;    // Se carga la dirección de donde se obtendrá la lectura
    EECON1bits.EEPGD = 0;
    EECON1bits.RD = 1;
    dato = EEDAT;    // Se guarda la lectura en la variable
    __delay_ms(20);
    return dato;     // Se retorna la lectura obtenida de la EEPROM
}

void EEPROM_Write(unsigned char address, char write){
    EEADR = address;    // Se carga la dirección de la EEPROM en donde se escribirá
    EEDAT = write;      // Se carga la escritura que se realizará en la EEPROM
    EECON1bits.EEPGD = 0;
    EECON1bits.WREN = 1;// Se habilita el bit de Escritura
    INTCONbits.GIE = 0; // Se desactivan las interrupciones globales
    EECON2 = 0x55;      // Proceso de seguridad
    EECON2 = 0xAA;      //
    EECON1bits.WR = 1;  //
    INTCONbits.GIE = 1; // Se activan las interrupciones globales
    __delay_ms(20);
}

void EEPROM_Save(unsigned char i, unsigned char Qd, unsigned char Qt, unsigned char Qr, unsigned char Qg, unsigned char Qb){
    EEPROM_Write(50,i);//configuraciones inicializadas o por default
    EEPROM_Write(51,Qd);//distancia
    EEPROM_Write(52,Qt);//tiempo
    EEPROM_Write(53,Qr);//carga PWM para rojo
    EEPROM_Write(54,Qg);//carga PWM para verde
    EEPROM_Write(55,Qb);//carga PWM para azul
}
