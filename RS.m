classdef RS
    %RS 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        ord;
        k;
        n;
        genpoly;
    end
    
    methods
        function obj = RS(n,k,ord)
            %RS 构造此类的实例
            %   此处显示详细说明
            if n>2^ord-1
                error('n beyond length limit');
            end
            obj.n=n;
            obj.k=k;
            obj.ord=ord;
            root=gf(2,ord);
            obj.genpoly=gf(1,ord);
            for i=1:n-k
                obj.genpoly=conv(obj.genpoly,[gf(1,ord),root^(i-1)]);
            end
            
        end
        
        function code=encode1(obj,mess)
            genlen=obj.n-obj.k;
            [~,check]=deconv([mess,gf(zeros(1,genlen),obj.ord)],obj.genpoly);
            code=[mess,check(end-genlen+1:end)];            
        end
         function res=decode1(obj,sig)
             genlen=obj.n-obj.k;
              S=gf(zeros(1,genlen),obj.ord);
              root=gf(2,obj.ord);
              
              for i=1:length(S)
                  S(i)=polyval(sig,root^(i-1));
              end
%                 [L,C]=obj.berlekamp(S);
                 [errnum,sigmapoly]=obj.BM(S);
                 errind=obj.SearchInd(sigmapoly,errnum);
                 synpoly=fliplr(S);
                 errval=obj.forney(synpoly,sigmapoly,errind);

                 errpoly=gf(zeros(1,obj.n),obj.ord);

                 for i=1:errnum
                     errpoly(errind(i))=errval(i);
                 end
                 errpoly=fliplr(errpoly);
                 respoly=sig+errpoly;
                 res=respoly(1:obj.k);

        end

        function [L,C] = BM(obj,s)
            %Copilot
            % s: 输入序列
            % m: 有限域的阶数
          
            ns = length(s);
           
            C = gf([1 zeros(1, ns-1)], obj.ord); % 连接多项式
            B = gf([1 zeros(1, ns-1)],obj.ord); % 辅助多项式
            L = 0; % 连接多项式的长度
            m = 0; % 上一次更新的位置
            b = gf(1, obj.ord); % 上一次更新时的差错值
        
            for i = 1:ns
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
                for j = 1:ns-i+m
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
            exp=2^obj.ord-1;
            for i=0:obj.n-1
                ex=exp-i;
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
            genlen=obj.n-obj.k;
            wpoly=conv(synpoly,sigmapoly);

            [~,wpoly]=deconv(wpoly,gf([1,zeros(1,genlen)],obj.ord));

            
            dsigmapoly=gf(zeros(1,length(sigmapoly)),obj.ord);
            
            for i=1:length(dsigmapoly)
                ind=length(dsigmapoly)-i+1;
                if mod(ind,2)==0
                   dsigmapoly(i+1)=sigmapoly(i);
                end
            end
          
            errnum=length(errind);
            errval=gf(zeros(1,errnum),obj.ord);
            root=gf(2,obj.ord);
            for i=1:errnum
                ex=errind(i)-1;
                X=root^ex;
                Xm=X^-1;
                errval(i)=-((X*polyval(wpoly,Xm))/polyval(dsigmapoly,Xm));
            end

        end

    end
end

