function [out] = RSencoder(input)
% input matrix (n*514,1)

m = 10; % Number of bits in each symbol
k = 514; % Codeword length and message length
t=15;
n=k+2*t;
genpoly=gf([1, 575, 552, 187, 230, 552, 1,...
    108, 565, 282, 249, 593, 132, 94, 720, 495,...
    385, 942, 503, 883, 361, 788, 610, 193, 392,....
    127, 185, 158, 128, 834, 523],m);

mab_reshape=gf(reshape(input,[],514),m);
code=rsenc(mab_reshape,n,k,genpoly);
out=code.x(:);
%out=code.x(:);

end

