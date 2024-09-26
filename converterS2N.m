function [res] = converterS2N(str)
     len=length(str);
     temp=char(1,len*4);
     for i=1:len
         temp_s=hex2bin(str(len-i+1));
         temp(4*(len-i)+1:4*(len-i+1))=temp_s(1:4);
     end
     lens=floor(len*4/10);
     
     res=uint32(zeros(1,lens));
     for j=1:lens
        % mid1=temp((j-1)*10+1:j*10)';
         %mid2=bin2dec(mid1);
        % res(lens-j+1)=str2num(mid2);
         %res(lens-j+1)=str2num(bin2dec(temp((j-1)*10+1:j*10)));
         res(lens-j+1)=bin2dec(temp((j-1)*10+1:j*10)');
     end
     
     
end

