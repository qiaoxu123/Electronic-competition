x=90:0.1:110;
y=0.28*x;
int1=fix(y);
frac=y-int1;
frac2=frac*2^24;
frac3=fix(frac2);
int_r=dec2hex(int1);
frac_r=dec2hex(frac3);
