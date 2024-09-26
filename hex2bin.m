function [res] = hex2bin(str)
  switch str
      case '0'
        res='0000';
      case '1'
           res='0001';
      case '2'
           res='0010';
      case '3'
           res='0011';
      case '4'
           res='0100';
      case '5'
            res='0101';
      case '6'
           res='0110';
      case '7'
            res='0111';
      case '8'
             res='1000';
      case '9'
           res='1001';
      case 'a'
           res='1010';
      case 'b'
           res='1011';
      case 'c'
           res='1100';
      case 'd'
           res='1101';
      case 'e'
           res='1110';
      case 'f'
           res='1111';
      otherwise
          res='0000';
          
          
          
  end

end

