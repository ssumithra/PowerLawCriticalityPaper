function[A]=check(N)
A=bwlabel(N,4);
n = size(N,1);
for j=1:n
    if(A(n,j)>0 && A(1,j)>0 && A(n,j)< A(1,j))
        x=A(1,j);y=A(n,j);
        for k=1:n
            for l=1:n
                if(A(k,l)==x)
                    A(k,l)=y;
                end
            end
        end
    elseif(A(n,j)>0 && A(1,j)>0 && A(n,j)> A(1,j))
        x=A(n,j);y=A(1,j);
        for k=1:n 
            for l=1:n
                if(A(k,l)==x)
                    A(k,l)=y;
                end
            end
        end
    end
end

for i=1:n
    if(A(i,n)>0 && A(i,1)>0 && A(i,n)<A(i,1))
        x=A(i,1);y=A(i,n);
        for k=1:n
            for l=1:n
                if(A(k,l)==x)
                    A(k,l)=y;
                end
            end
        end
    elseif(A(i,n)>0 && A(i,1)>0 && A(i,n)>A(i,1))
        y=A(i,1); x=A(i,n);
        for k=1:n
            for l=1:n
                if(A(k,l)==x) 
                    A(k,l)=y;
                end
            end
        end
    end
end

        