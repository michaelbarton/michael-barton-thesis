library(lattice)
data = read.csv(file='curve.csv')

data$change <- (data$change - 1)
data$biomass <- data$biomass * -1

envs = unique(data$env)
for(i in 1:length(envs)) {
  env = envs[i]
  data[data$env == env,]$biomass <- data[data$env == env,]$biomass - mean(data[data$env == env,]$biomass)
  
}

lines = c(2,3)

nit = subset = data[data$env == 'nitrogen',]
glu = subset = data[data$env == 'glucose',]

plot(biomass ~ change,data=data,type='n')
lines(biomass ~ change, data=glu,lwd=2,lty=lines[1],col="grey10")
lines(biomass ~ change, data=nit,lwd=2,lty=lines[2],col="grey10")

legend("topleft",legend=envs,lty=lines)


