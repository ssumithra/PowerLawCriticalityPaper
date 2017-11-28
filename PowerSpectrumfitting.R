#load packages minpack.lm, nlstools
# set the working directory to the folder containing the powerspectra files for a the q and p values of interest and read all the files 


Gallpatches<-list.files(getwd(),recursive=TRUE)
Gallpatches #check to make sure that the only files in the folder are the pow-spectra for all the replicates of the chosen p and q values
 GVps<-lapply(Gallpatches,function(x){read.csv(x,header=TRUE)}) 
 GPSpec=GVps
 GPSpecF = lapply(GPSpec, function(x){x[,2]})
 

Xvec<-(0:512)/1024
ds<-data.frame(y=unlist(GPSpecF),x=rep(Xvec,50))

#to fit the power-law function
dataC<-matrix(nrow=length(Xvec)-1,ncol=3)
rhs<-function(x,b0,b1){b0*x^b1}

PSpecAVG<-rep(0,times=length(ds$x)/50)
SDvec<--rep(0,times=length(ds$x)/50)
for(i in 1:length(PSpecAVG)){PSpecAVG[i]<-mean(c(ds$y[which(ds$x==(i-1)/1024)]))
SDvec[i]<-sqrt(var((c(ds$y[which(ds$x==(i-1)/1024)]))))}
 
for(i in 1:50){
   
UC=0.3
   
ds1<-ds[-c(which(ds$x<i/1024),which(ds$x>UC)),]
PSpecAVG1<-PSpecAVG[(i+1):(min(which(ds$x>UC))-1)]
SDvec1<-SDvec[(i+1):(min(which(ds$x>UC))-1)]
m.2<-lm(log(ds1$y)~log(ds1$x))
  a<-summary(m.2)$coefficients[2]
 C<-exp(summary(m.2)$coefficients[1])

 cx = 1-cumsum(as.numeric(PSpecAVG1)/sum(PSpecAVG1))# construct the empirical CDF
 drat<-Xvec[(i+1):(min(which(ds$x>UC))-1)]
 cf<-1-cumsum((C*drat^a)/
                sum(C*drat^a))
 dataC[i,1]<-max(abs(cx-cf))
 dataC[i,2]<-a
 dataC[i,3]<-C
 }
 
 i = which(dataC[1:50,1]==min(dataC[1:50,1]))
 
ds1<-ds[-c(which(ds$x<i/1024),which(ds$x>UC)),]
SDvec1<-SDvec[(i+1):(min(which(ds$x>UC))-1)]

m.1<-lm(y~x,data=log(ds1))
 summary(m.1) 
 
 #######################
 

 #to fit lorentzian function
 
 rhs<-function(x,k,a,x0){k*a/((x-x0)^2+a^2)}
 

   m.2 <- nlsLM(formula=y~ rhs(x,k,a,x0),data=ds,start=list(k=0.000001,x0=0,
                                                             a=0.1),
                weights = wfct(1/ds$y),control = nls.lm.control(maxiter=1024,nprint=1))
#the lorentzian is fit over the entire function and there is no estimation of xmin required.
 summary(m.2) 