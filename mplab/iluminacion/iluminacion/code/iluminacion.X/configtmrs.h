////////////////////////////////////////////////////////////////////
//Archivo de cabecera para el uso del módulo USART PIC con el XC8///
///////////////////////////////////////////////////////////////////
 
#ifndef CONFIGTMRS_H
#define	CONFIGTMRS_H

#ifdef	__cplusplus
extern "C" {
#endif
    void TMR0_Init(void);
    void TMR0_Cnf(void);
    void TMR0_Stop(void);
    void TMR2_Cnf(void);
    void TMR2_Stop(void);
#ifdef	__cplusplus
}
#endif
 
#endif	/* CONFIGTMR_H */