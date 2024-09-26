clear;
clc;
n=255;
k=230;
m=8;

rs=RS(n,k,m);

messval=randi([0,2^m-1],1,k);
mess=gf(messval,m);

code=rs.encode1(mess);

errind=[3,4,102,234];
errmes=gf([6,4,17,36],m);
sig=code;
for i=1:length(errind)
    sig(n+1-errind(i))=sig(n+1-errind(i))+errmes(i); 
end


res=rs.decode1(sig);

comp=res+mess;

compval=comp.x;

[ind,val]=find(compval);

if isempty(val)
    disp('fec successful !');
else
    disp('fec fail !');
end
