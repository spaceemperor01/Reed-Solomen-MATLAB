clear;
clc;
rs=RS544514();
messval=randi([0,2^10-1],1,514);
mess=gf(messval,10);

code=rs.encode1(mess);
codeval=code.x;

% codevalsys=RSencoder(messval);
% 
% err=length(find(codeval-codevalsys'));

errind=[3,4,102,456];
errmes=gf([6,4,17,36],10);
sig=code;
for i=1:length(errind)
    sig(545-errind(i))=sig(545-errind(i))+errmes(i); 
end


res=rs.decode1(sig);

comp=res+mess;

compval=comp.x;

[ind,val]=find(compval);

