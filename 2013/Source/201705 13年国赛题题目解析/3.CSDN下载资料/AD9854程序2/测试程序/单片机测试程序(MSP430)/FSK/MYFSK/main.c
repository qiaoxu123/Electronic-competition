#include "msp430x54x.h"
#include "AD9854.h"
#include "ad9854sin.h"
//附带定时器p4.3产生方波自己测试用
void time_set();
//**************主函数***************//
int main( void )   
{ 
  WDTCTL = WDTPW + WDTHOLD;// Stop watchdog timer to prevent time out reset
  time_set();
  init_9854();
  ad9854f(30000000);
  ad9854v(1);
  P4DIR |=BIT3; 
  P4DIR&=~BIT4;
  P4REN |= BIT4;
  P4OUT |=BIT4;
  TA1CCTL0 = CCIE;  // CCR0 interrupt enabled
  TA1CCR0 = 30000;
  TA1CTL = TASSEL__SMCLK + MC__CONTINOUS + TACLR; // SMCLK, contmode, clear TAR
  __bis_SR_register(GIE);
  while(1)
  {
    if((P4IN&BIT4)==0)
    {
      ad9854f(30000000);
    }
    else
    {
      ad9854f(10000000);
    }
  }
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
// Timer A0 interrupt service routine
#pragma vector=TIMER1_A0_VECTOR
__interrupt void TIMER1_A0_ISR(void)
{
  P4OUT ^= BIT3;                            // Toggle P1.0
  TA1CCR0 += 30000;                         // Add Offset to CCR0 150us  2000/x=150
}
