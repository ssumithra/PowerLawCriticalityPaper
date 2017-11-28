function [finalpspc,f]=patchsizes(A)
%%producing vector of sizes of patches
C=reshape(A,1,1024*1024);
B=zeros(max(max(A)),2);
B(:,1)=1:max(max(A));
for z=1:max(max(A))
    B(z,2)=sum(C==B(z,1));
end

f=B(:,2);
f(f==0)=[];

finalpspc=zeros(length(unique(f)),2);
finalpspc(:,1)=unique(f);
for z=1:length(unique(f))
finalpspc(z,2)=sum(f==finalpspc(z,1));
end

