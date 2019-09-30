### Questions 7 ###

X<-c(0, 3, 8, -2, -10, 9, 6, 7, 100, 1)

RobbyLovesJenny <- function(var) {
  Mean<-summary(var)[4]
  StdDev<-sd(var)
  MaxNum<-length(var)
  NEW=c()
  for (num in 1:MaxNum){
    value<-var[num]
    Zscore<-(value-Mean)/StdDev
    NEW<-paste(NEW,Zscore)
  }
  print(NEW)
}

ZscoreMan<-RobbyLovesJenny(X)
ZscoreAuto<-scale(X, center=TRUE, scale=TRUE)

class(ZscoreMan)
#[1] "character"
class(ZscoreAuto) #Also Tells SD and Mean Automatrically
#[1] "matrix"

### Questions 10 ###

install.packages("ggplot2")
library(ggplot2)
install.packages("RColorBrewer")
library(RColorBrewer)
suppressMessages(require(RColorBrewer))
SampleSizes<-c(10, 50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 1000, 5000,10000,15000,20000,25000,30000,35000,40000,45000,50000,60000,70000,80000,90000,100000,120000,140000)
MaxNum<-length(SampleSizes)
rnorm_fixed <- function(n,mean,sd) { mean+sd*scale(rnorm(n)) }

FINAL<-data.frame()
for (num in 1:MaxNum){
  Size<-(SampleSizes[num])/2
  High <- data.frame(rnorm_fixed(Size,100,2))
  names(High)[1]<-"Values"
  High$Group<-1
  Low <- data.frame(rnorm_fixed(Size,90,2))
  names(Low)[1]<-"Values"
  Low$Group<-2
  COMBINED<-rbind(High,Low)
  NEW<-t.test(COMBINED$Values,COMBINED$Group)
  tstat<-t.test(COMBINED$Values,COMBINED$Group)[1]
  df<-t.test(COMBINED$Values,COMBINED$Group)[2]
  pval<-t.test(COMBINED$Values,COMBINED$Group)[3]
  row<-data.frame(c((Size*2),tstat,df,pval))
  names(row) <- c("SampleSize","T-stat","DegreeFreedom","P-value")
  FINAL<-rbind(FINAL,row)
}

ggplot() + 
  geom_point(data=FINAL, aes(SampleSizes,`T-stat`), colour="#000000", size=4) +
  geom_smooth(data=FINAL,aes(SampleSizes,`T-stat`),fill="#00aaff", colour="#00aaff", size=2)

### Looks Like logarithmic Trajectory But Actually the Curve Never Tappers off
### Remove Additional values on line 33 to only focus on the ones professor suggested

