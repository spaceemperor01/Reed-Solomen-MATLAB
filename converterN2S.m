function [str] = converterN2S(input)
  num=uint32(fliplr(input));
  len=length(num);
  lens=floor(len*10/4);
  temp=char(1,10*len);
  str=char(1,lens);
  for i=1:len
      mid=dec2bin(num(i),10);
      temp((i-1)*10+1:i*10)=mid(1:10);
  end
  
  for j=1:lens
      str(j)=bin2hex(temp(4*(j-1)+1:4*j)');
      
  end
  
  
end

