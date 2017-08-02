#ifndef	__AD9854_h__
#define	__AD9854_h__

//	write your header here
#define uint  unsigned int
#define uchar unsigned char
#define ulong unsigned long

sbit AD9854_FDATA  = P3^3;   //AD9854 FSK,PSK¿ØÖÆ
sbit AD9854_OSK    = P3^2;   //AD9854 OSK¿ØÖÆ¶Ë
	  
extern void AD9854_Init(void);						  	         	  
extern void AD9854_SetSine(ulong Freq,uint Shape);	  		  
extern void AD9854_SetSine_double(double Freq,uint Shape);
extern void AD9854_InitFSK(void);				
extern void AD9854_SetFSK(ulong Freq1,ulong Freq2);					  
extern void AD9854_InitBPSK(void);					  
extern void AD9854_SetBPSK(uint Phase1,uint Phase2);					
extern void AD9854_InitOSK(void);					 
extern void AD9854_SetOSK(uchar RateShape);					  
extern void AD9854_InitAM(void);					 
extern void AD9854_SetAM(uint Shape);					
extern void AD9854_InitRFSK(void);					 
extern void AD9854_SetRFSK(ulong Freq_Low,ulong Freq_High,ulong Freq_Up_Down,ulong FreRate);				

#endif