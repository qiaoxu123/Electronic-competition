#include "msp430x54x.h"
#include "AD9854.h"
#include "ad9854sin.h"
void time_set();
//**************主函数***************//
int main( void )   
{ 
  double i;
  i=0.0;
  WDTCTL = WDTPW + WDTHOLD;// Stop watchdog timer to prevent time out reset
  time_set();
  init_9854();
  ad9854f(1000000);
  ad9854v(2.9);
  while(1);
}
//**********************系统整体时钟设定****************//
void time_set()
{
 P11DIR = BIT2 + BIT1 + BIT0;              // P11.2,1,0 to output direction
 P11SEL = BIT2 + BIT1 + BIT0;              // P11.2 to output SMCLK, P11.1
 P5SEL |= 0x0C;                            // Port select XT2
 P7SEL |= 0x03;                            // Port select XT1
 UCSCTL6 &= ~(XT1OFF + XT2OFF);            // Set XT1 & XT2 On
 UCSCTL6 |= XCAP_3;                        // Internal load cap
   do
  {
    UCSCTL7 &= ~(XT2OFFG + XT1LFOFFG + XT1HFOFFG + DCOFFG);
                                            // Clear XT2,XT1,DCO fault flags
    SFRIFG1 &= ~OFIFG;                      // Clear fault flags
    for(unsigned int i = 0xff; i >0; i--);
  }while (SFRIFG1&OFIFG);                   // Test oscillator fault flag
  UCSCTL6 &= ~XT2DRIVE0;                    // Decrease XT2 Drive according to
                                            // expected frequency
  UCSCTL4 |= SELA__XT1CLK + SELS__DCOCLK+SELM__XT2CLK ;     // Select SMCLK, ACLK source and DCO source
}
