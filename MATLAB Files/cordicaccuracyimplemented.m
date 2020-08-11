
clear all;close all;clc;
data=load('implemented values.txt')
cos_calc=data(:,1);
sin_calc=data(:,2);
angle=linspace(0,2*pi,360);
actual_cos=cos(angle);
actual_sin=sin(angle);
actual_cos=transpose(actual_cos);
actual_sin=transpose(actual_sin);
error_cos=(actual_cos-cos_calc);
error_sin=(actual_sin-sin_calc);
subplot(211)
plot(angle,error_cos,'-');
title('Error in cos')
subplot(212)
plot(angle,error_sin,'-');
title('Error in sin')
psin=norm(actual_sin);
psinerr=norm(error_cos);
psin=psin^2;
psinerr=psinerr^2;
psin=psin/length(actual_sin);
psinerr=psinerr/length(error_sin);
snrsin=psin/psinerr;
snrsindb=10*log10(snrsin);
pcoserr=(norm(error_cos)^2)/length(error_cos);
pcos=(norm(actual_cos)^2)/length(actual_cos);
snrcos=pcos/pcoserr;
snrcosdb=10*log10(snrcos);
disp(sprintf("Snr of sin=%f or %f db",snrsin,snrsindb));
disp(sprintf("Snr of cos=%f or %f db",snrcos,snrcosdb));
