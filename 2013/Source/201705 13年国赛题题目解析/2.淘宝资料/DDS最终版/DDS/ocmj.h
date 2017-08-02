#ifndef	__OCMJ_h__
#define	__0CMJ_h__

#define uint  unsigned int
#define uchar unsigned char

extern void init_lcd (void);
extern void set_position(unsigned int xx,unsigned int yy);
extern void send_str(uchar code *cc);
extern void send_img (uchar code *img);
extern void lat_disp (uchar data1,uchar data2);
extern void clear (void);
extern void clear_line(uint line);
extern void send_chin(uchar code *cc);
extern void send_char(uchar cc);

#endif