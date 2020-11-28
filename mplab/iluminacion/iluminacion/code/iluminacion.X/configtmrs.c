#include <pic16f887.h>
#include "configtmrs.h"
/*
 * File:   cnfTMRs.c
 * Author: Dell
 *
 * Created on 28 de octubre de 2020, 10:10 AM
 */
void TMR0_Init(void){
    TMR0_Cnf();
    INTCON = 0b10100000;
}

void TMR0_Cnf(void){ //interrupcion cada 0.00160000 sec * 625 = 1 seg
    TMR0 = 0;             // preset for timer register
    OPTION_REG = 0b10000111;//presc 1:256
    INTCON = 0b10100000;
}

void TMR0_Stop(void){
  TMR0IF = 0;
  TMR0IE = 0;
  TMR0 = 0;
}

void TMR2_Cnf(void){
    T2CON = 0b00000101;             // Configura el preescaler para una frecuencia 5 KHZ (Para un oscilador de 16Mhz)
    TMR2 = 0;
    PR2 = 255;                       // Configuración inicial del periodo PWM, ligada directamente a la frecuencia del pulso
}

void TMR2_Stop(void){
  TMR2IF = 0;
  TMR2IE = 0;
  TMR2 = 0;
  CCPR1L = 0;
  CCPR2L = 0;
}