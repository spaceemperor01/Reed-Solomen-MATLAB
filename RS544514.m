classdef RS544514
    %RS544514 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        ord ; % Number of bits in each symbol
        k ;
        genpoly;
        genpolylog;

    end
    
    methods
        function obj = RS544514()
            %RS544514 构造此类的实例
            %   此处显示详细说明
            obj.ord=10;
            obj.k=514;
            obj.genpoly=gf([1, 575, 552, 187, 230, 552, 1,...
    108, 565, 282, 249, 593, 132, 94, 720, 495,...
    385, 942, 503, 883, 361, 788, 610, 193, 392,....
    127, 185, 158, 128, 834, 523],obj.ord);
            obj.genpolylog=log(obj.genpoly);
        end

        function code=encode1(obj,mess)
            code=[mess,gf(zeros(1,30),obj.ord)];
            
            for i=1:514
                p=code(i);
                code(i:i+30)=code(i:i+30)+p*obj.genpoly;
            end
            code=[mess,code(515:end)];
        end

        function res=decode1(obj,sig)
              S=gf(zeros(1,30),obj.ord);
              root=gf(2,obj.ord);
              
              for i=1:length(S)
                  S(i)=polyval(sig,root^(i-1));
              end
%                 [L,C]=obj.berlekamp(S);
                 [errnum,sigmapoly]=obj.BM(S);
                 errind=obj.SearchInd(sigmapoly,errnum);
                 synpoly=fliplr(S);
                 errval=obj.forney(synpoly,sigmapoly,errind);

                 errpoly=gf(zeros(1,544),obj.ord);

                 for i=1:errnum
                     errpoly(errind(i))=errval(i);
                 end
                 errpoly=fliplr(errpoly);
                 respoly=sig+errpoly;
                 res=respoly(1:514);

        end

        function [ L, K ] = berlekamp( obj,S)
            %BERLEKAMP Constructs LFSR with minimal length that generates specified
            %vector S in order S1, S2, ... Sn
            %LFSR must be initialized with values S1..SL
            %Returns length L and feedback coefficients Ki (i=1..L)
                
                L = 0;
                K = zeros(1,0);
                if length(S) < 1
                    return;
                end
                if length(S) < 2
                    L = 1;
                    K = [K 0];
                    return;
                end
                
                L = 1;
                K = gf(1,obj.ord);
                %m = 1 - some iteration (LFSR state), at which we had nonzero
                %discrepancy
                %Before iter. 1 register produced nothing (zeroes) and had zero length
                %Therefore, discrepancy was equal to S(1)
                m = 1;
                dis_m = S(1);
                L_m = 0;
                K_m = gf(zeros(1,0),obj.ord);
                %Iterative LFSR construction..
                %Iteration number. Register at iteration "it" should be able to
                %generate correct Sit. Register at previous iteration "it-1" WAS able
                %to generate correct Sit-1
                for it=2:length(S)
                    %Compute next generated symbol
                    Sit = gf(0,obj.ord);
                    for j=1:L
                        Sit = Sit+ K(j)*S(it - j);
                    end
                    %Discrepancy
                    dis = Sit+S(it);
                    if dis == gf(0,obj.ord)
                        %Skip if register is already able to generate correct Sit
                        continue;
                    end
                    %Else, correct register in some way...
                    %Calculate scaling coefficient A, so that dis_m * A = dis
                    A = dis/dis_m;
                    %Build up register that extracts dis_m...
                    L_ext = L_m + it - m;
                    K_ext = [gf(zeros(1, it - m - 1),obj.ord), gf(1,obj.ord), K_m];
                    if L_ext > L
                        %Remember current register...
                        L_m = L;
                        K_m = K;
                        m = it;
                        dis_m = dis;
                        K = [K ,gf(zeros(1, L_ext - L),obj.ord)];
                        L = L_ext;
                    end
                    if L_ext < L
                        %Auxiliary register's length can be smaller than L...
                        K_ext = [K_ext,gf( zeros(1, L - L_ext),obj.ord)];
                    end
                    %Add two registers o_O, Resulting register should have zero
                    %discrepancy(compensated), and therefore should produce correct Sit
                    for j=1:L
                        K(j) = K(j)+K_ext(j)* A;
                    end
                end
                K=fliplr([gf(one,obj.ord),K]);
                %Calculate discrepancy at last stage
                %Sit = 0;
                %for j=1:L
                %    Sit = bitxor(Sit, gf_mul(K(j), S(it - j), powtable, fsize));
                %end
                %dis = bitxor(Sit, S(it))
        end

%         function [C,L]=BM(obj,S)
%             L=0;
% 
%         end


        function [L,C] = BM(obj,s)
            %Copilot
            % s: 输入序列
            % m: 有限域的阶数
          
            n = length(s);
           
            C = gf([1 zeros(1, n-1)], obj.ord); % 连接多项式
            B = gf([1 zeros(1, n-1)],obj.ord); % 辅助多项式
            L = 0; % 连接多项式的长度
            m = 0; % 上一次更新的位置
            b = gf(1, obj.ord); % 上一次更新时的差错值
        
            for i = 1:n
                % 计算差错值
                d = s(i);
                for j = 1:L
                    d = d + C(j+1) * s(i-j);
                end
        
                if d == 0
                    continue;
                end
        
                T = C;
                p = d / b;
                for j = 1:n-i+m
                    C(i-m+j) = C(i-m+j) - p * B(j);
                end
        
                if 2*L <= i-1
                    L = i - L;
                    B = T;
                    b = d;
                    m = i;
                end
            end
        
            C = C(1:L+1); % 连接多项式的有效部分
            C=fliplr(C);
        end
        function errind=SearchInd(obj,sigmapoly,errnum)
            errind=zeros(1,errnum);
            root=gf(2,obj.ord);
            Zero=gf(0,obj.ord);
            cnt=1;
            for i=0:543
                ex=1023-i;
                ch=polyval(sigmapoly,root^ex);
                if(ch==Zero)
                   errind(cnt)=i+1;
                   cnt=cnt+1;
                   if cnt>errnum
                       break;
                   end
                end
            end
        end

        function errval=forney(obj,synpoly,sigmapoly,errind)

            wpoly=conv(synpoly,sigmapoly);

            [~,wpoly]=deconv(wpoly,gf([1,zeros(1,30)],10));

            
            dsigmapoly=gf(zeros(1,length(sigmapoly)),10);
            
            for i=1:length(dsigmapoly)
                ind=length(dsigmapoly)-i+1;
                if mod(ind,2)==0
                   dsigmapoly(i+1)=sigmapoly(i);
                end
            end
          
            errnum=length(errind);
            errval=gf(zeros(1,errnum),10);
            root=gf(2,10);
            for i=1:errnum
                ex=errind(i)-1;
%                 exm=1023-ex;
                X=root^ex;
                Xm=X^-1;
                errval(i)=-((X*polyval(wpoly,Xm))/polyval(dsigmapoly,Xm));
            end

        end





        
      
    end
end

