q=0 #enter the q value of the simulations that produced the set of realisations 
p= 0.7225 #the p value of the simulations that produced the set of realisations
Gallpatches<-list.files(getwd(),recursive=TRUE)
Gallpatches
GPSpecq0p62275<-lapply(Gallpatches,function(x){read.csv(x,header=TRUE)})
GPSpec<-lapply(GPSpecq0p62275,function(x){rspec(x)[[2]]})
for i in (1:length(GPSpec)){write.csv(GPSpec[[i]],paste("PowSpecq",q,"p",p,"patch",i,".csv",sep=""))}
