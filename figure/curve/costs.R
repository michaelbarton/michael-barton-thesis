rm(list=ls())
library(lattice)

data <- data.frame(
  cost        = c(11.96460,7.30842,1.53572,9.99939,14.99990,5.00001),
  environment = c("Carbon Limited","Carbon Limited","Carbon Limited","Nitrogen Limited","Nitrogen Limited","Nitrogen Limited"),
  acid        = c("Tryptophan","Histidine","Glycine","Tryptophan","Histidine","Glycine")
)

trellis.par.set("superpose.polygon", 
  list(
    col=c("grey30","grey50","grey70"),
    border=c("grey30","grey50","grey70")
  )
)


postscript("costs.eps",width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
barchart(
  cost ~ environment, 
  groups=acid,
  auto.key=TRUE,
  horiz=FALSE,
  ylab="Estimated absolute cost",
  data=data)
graphics.off()
