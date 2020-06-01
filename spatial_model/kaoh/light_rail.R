pacman::p_load(readr, dplyr, sf, tmap, stringr)

# Read in the 高雄捷運輕軌 data
L = st_read("kaoh/light_rail/LRT_1090102.shp")
L = subset(L,LRTSYS=="高雄捷運")
L = st_transform(L, crs=4326)
L = L %>% mutate_if(is.factor,as.character)

# Read in the house price data 房產時價登錄資料
load("kaoh/house_price.rdata")
A <- st_as_sf(D, coords=c("E","N"), crs=4326)

# calculate distance
t0 = Sys.time()
dx = st_distance(A, L)
Sys.time() - t0
dim(L)
A$dx = apply(dx,1,min)

# PLOT
set.seed=(1)
Houses = A %>% filter(dx < 2000) %>% sample_n(1000)
KaohTown = subset(twTown, COUNTY=="高雄市") 
tm_shape(Houses) + 
  tm_dots(col='dx',size=0.1,alpha=0.8,n=8) +
  tm_shape(L) + 
  tm_lines(col='LRTID',lwd=3,palette=c("green","orange")) +
  tm_shape(KaohTown) + tm_borders(col="red") +
  tm_text(text="TOWN",col="firebrick")

save_tmap(filename="kaohLR.html")
