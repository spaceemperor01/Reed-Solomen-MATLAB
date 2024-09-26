function [res] = bin2hex(str)
  switch str
      case '0000'
        res='0';
      case '0001'
           res='1';
      case '0010'
           res='2';
      case '0011'
           res='3';
      case '0100'
           res='4';
      case '0101'
            res='5';
      case '0110'
           res='6';
      case '0111'
            res='7';
      case '1000'
             res='8';
      case '1001'
           res='9';
      case '1010'
           res='a';
      case '1011'
           res='b';
      case '1100'
           res='c';
      case '1101'
           res='d';
      case '1110'
           res='e';
      case '1111'
           res='f';
      otherwise
          res='0';
          
          
          
  end

end