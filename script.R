library(dplyr)
library(ggplot2)
library(readxl)
library(stringr)


# Check if command-line arguments are provided
if (length(commandArgs(trailingOnly = TRUE)) == 0) {
  stop("Error: No command-line arguments provided.")
}

# Extract command-line arguments
args <- commandArgs(trailingOnly = TRUE)



data <- read_excel(args[1],skip=7)
data <- slice(data, 1:(n() - 5))
data %>%
	group_by(`Sample Name`,`Target Name`) %>%
	summarise(mean = mean(Cт)) %>%
	summarise(diff = mean[2]-mean[1]) %>%
	mutate(`Sample Name` = str_sub(`Sample Name`, end = -3)) -> tdata

tdata %>% group_by(`Sample Name`) %>% summarise(mean = mean(diff)) -> means

tdata %>% 
	mutate(ctr_diff = diff - as.double(means[1,2])) %>%
	mutate(cycles = 2**(-ctr_diff)) %>%
	arrange(`Sample Name`) -> fdata

fdata %>% group_by(`Sample Name`) %>%
	summarise(mean = mean(cycles),sem = sd(cycles)/sqrt(n())) -> errdata

ggplot(data=errdata, aes(x = `Sample Name`, y = mean))+
	geom_col(color='black',fill='white')+
	geom_errorbar(aes(ymin=mean-sem,ymax=mean+sem),width=0.25)+
	geom_jitter(data=fdata, aes(x=`Sample Name`, y = cycles), color="black", size=0.8, alpha=0.9, width=0.1)+
	labs(x = NULL, y = NULL)

ggsave("plot.png")



