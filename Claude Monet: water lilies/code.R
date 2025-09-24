library(ggplot2)
library(dplyr)
library(ggExtra)
library(ggthemes)

#==============================================================================#
# load and prep data
#==============================================================================#
SP500 <- read.csv("S&P500.csv")
SP500$Date = as.Date(SP500$Date)

SSE <- read.csv("SSE.csv")
SSE$Date = as.Date(SSE$Date)

Euro_stoxx50 <- read.csv("Euro_stoxx_50.csv")
Euro_stoxx50$Date = as.Date(Euro_stoxx50$Date)

FTSE <- read.csv("FTSE100.csv")
FTSE$Date = as.Date(FTSE$Date)

TSX <- read.csv("TSX.csv")
TSX$Date = as.Date(TSX$Date)

Nikkei <- read.csv("Nikkei225.csv")
Nikkei$Date = as.Date(Nikkei$Date)

#==============================================================================#
# transform into percentage log returns
#==============================================================================#
SP500.rt = data.frame(date=head(SP500$Date, -1),
                      return=log(SP500$Price[-length(SP500$Date)]/SP500$Price[-1])*100)


SSE.rt = data.frame(date=head(SSE$Date, -1),
                    return=log(SSE$Close[-length(SSE$Date)]/SSE$Close[-1])*100)


Euro50.rt = data.frame(date=head(Euro_stoxx50$Date, -1),
                       return=log(Euro_stoxx50$Close[-length(Euro_stoxx50$Date)]/Euro_stoxx50$Close[-1])*100)

FTSE.rt = data.frame(date=head(FTSE$Date, -1),
                     return=log(FTSE$Close[-length(FTSE$Date)]/FTSE$Close[-1])*100)

TSX.rt = data.frame(date=head(TSX$Date, -1),
                    return=log(TSX$Close[-length(TSX$Date)]/TSX$Close[-1])*100)

Nikkei.rt = data.frame(date=head(Nikkei$Date, -1),
                       return=log(Nikkei$Close[-length(Nikkei$Date)]/Nikkei$Close[-1])*100)


# define helper function to fill in missing values with return zero
fill_miss_values <- function(rt, char) {
  
  data <- rt %>%
    mutate(month = as.integer(format(date, "%m")),
           day = as.integer(format(date, "%d")))
  
  updated = c()
  for (i in 1:12) {
    records = data[which(data$month==i),"day"]
    missings = which(!(1:31 %in% records))
    new = cbind(rep(NA, length(missings)),
                rep(0, length(missings)),
                rep(i, length(missings)),
                missings)
    updated = rbind(updated, new)
    }
  
  updated = data.frame(updated)
  names(updated) = c("date", "return", "month", "day")
  data.update = rbind(data, updated)
  
  data.update$index <- rep(char, nrow(data.update))
  
  # arrange month order as will be shown on Y-axis
  data.update$month = as.factor(data.update$month)
  data.update$month <- factor(data.update$month, 
                              levels = levels(data.update$month)[c(10:12, 1:9)])
  
  return(data.update)
  }

#==============================================================================#
# gather, combine, and adjust the updated data frames
#==============================================================================#
SP500.rt.update <- fill_miss_values(SP500.rt, "US: S&P 500")
SSE.rt.update <- fill_miss_values(SSE.rt, "CN: SSE Composite")
Euro50.rt.update <- fill_miss_values(Euro50.rt, "EU: EURO STOXX 50")
FTSE.rt.update <- fill_miss_values(FTSE.rt, "UK: FTSE 100")
TSX.rt.update <- fill_miss_values(TSX.rt, "CA: S&P/TSX Composite")
Nikkei.rt.update <- fill_miss_values(Nikkei.rt, "JP: Nikkei 225")

all <- rbind(SP500.rt.update, SSE.rt.update, 
             Euro50.rt.update, FTSE.rt.update,
             Nikkei.rt.update, TSX.rt.update)


# deal with extremes to make color palette more readable
all$return= abs(all$return) # focus on volatility or risk
upper = quantile(all$return,0.99) # get 99% VaR
all[which(all$return > upper),]$return = upper # modify data beyond 99% VaR as 99% VaR


# arrange the order in plotting
all$index = as.factor(all$index)
all$index <- factor(all$index, 
                    levels = levels(all$index)[c(6, 1, 3, 5, 2, 4)])

#==============================================================================#
# plot
#==============================================================================#
ggplot(all, aes(x=day, y=month, fill=return)) +
  geom_tile(color="white", size=0.5) +
  # Define and rescale the colors
  scale_fill_gradientn(
    colors = c("#8e9655","#909a62","#829164","#838f86","#8e959e","#9d9db0","#9a8e93", "#796258","#925e6a"),
    values = scales::rescale(quantile(test$return,c(0, 0.4, 0.45, 0.5, 0.7, 0.8, 0.9, 0.95, 1))),
    limits = c(0,quantile(test$return,1)) # limits of the color scale
    ) + 
  coord_equal() +
  facet_wrap(~index, ncol=2) +
  theme_minimal(base_size = 8) +
  removeGrid() +
  theme_tufte(base_family="Helvetica") +
  labs(x=NULL, y=NULL, title="The Pond of Trade War: Global Market Volatility Under a Monet Palette\n")+
  theme(plot.title=element_text(hjust=0.5, face="bold", size=20, colour = "#A18A3C")) +
  theme(legend.position = "bottom") +
  theme(strip.text=element_text(hjust=0.05, face="bold", colour = "#A18A3C"), size=15) +
  theme(plot.margin = unit(c(0.2, 0.1, 0.1, 0.1), "cm")) +
  theme(axis.text = element_text(size=10)) +
  theme(axis.ticks=element_blank()) +
  theme(legend.key.size=unit(0.5, "cm")) +
  theme(legend.key.width=unit(0.7, "cm")) +
  theme(legend.title = element_blank()) +
  theme(legend.text=element_text(size=10))
  
ggsave("test.jpeg", units="in", width=10, height=9, dpi=500)
