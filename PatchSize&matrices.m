N=1024 #system size
for q=0%0:0.00001:0.99999
INP=['tcp_q',num2str(q),'_spatial_data_PD.dat']; %set 0s according to resolution of q in simulations
k=dlmread(INP);
for j=999999:-1:1  %set according to resolution of p in the simulations
psd=0;
n=50 #this is the number of replicates
for i=1:n
kmat=reshape(k((999999-j)*N*N*n+((i-1)*N*N)+1:(999999-j)*N*N*n+(i*N*N)),N,N); %again modify according to resolution
csvwrite(['q',num2str(q),'p',num2str(j/1000000),'patch',num2str(i),'.csv'],kmat)
A=check(kmat);
[pig,hg]=patchsizes(A);
psd=[psd hg'];
end
psd(1)=[];
csvwrite(['q',num2str(q),'p',num2str(j/1000000),'PSD.csv'],psd)
end
end
