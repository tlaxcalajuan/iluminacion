////////////////////////////////////////////////////////////////////
//Archivo de cabecera para el uso del módulo USART PIC con el XC8///
///////////////////////////////////////////////////////////////////
 
#ifndef EEPROMLIB_H
#define EEPROMLIB_H

#ifdef	__cplusplus
extern "C" {
#endif
    unsigned char EEPROM_Read(unsigned char address);
    void EEPROM_Write(unsigned char address, char write);
    void EEPROM_Save(unsigned char i, unsigned char Qd, unsigned char Qt, unsigned char Qr, unsigned char Qg, unsigned char Qb);
#ifdef	__cplusplus
}
#endif
 
#endif	/* EEPROM_H */