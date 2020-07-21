clear
for i=1:31
    atanlut(i,1)=fi((2^32*(atan(2^(-(i-1))))/(2*pi)),1,32,0);
end
atanlut.bin