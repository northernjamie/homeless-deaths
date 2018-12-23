library(leaflet)
library(dplyr)
library(anytime)
library(webshot)
library(mapview)
library(htmlwidgets)
library(lubridate)

#### Get the Bureau data (with Lat/Long fields added) ####

homeless_deaths <- read.csv("~/Projects/Propolis_Stuff/All projects/Homelessness-Maps/2018-deaths.csv", stringsAsFactors = F)

#### Date manipulations ####

# if the day field is empty, put a 1 in it


homeless_deaths$dod_day_adj <- ifelse(is.na(homeless_deaths$dod_day),"1",homeless_deaths$dod_day)
homeless_deaths$dod_month_adj <- ifelse(is.na(homeless_deaths$dod_month),"1",homeless_deaths$dod_month)
homeless_deaths$dod_full <- as.Date(paste0(homeless_deaths$dod_year,'-',homeless_deaths$dod_month_adj,'-',homeless_deaths$dod_day_adj), format = '%Y-%m-%d')
homeless_deaths$weekbeginning <- cut(homeless_deaths$dod_full,'week')
homeless_deaths$weeknumber <- isoweek(ymd(homeless_deaths$weekbeginning))
homeless_deaths <- homeless_deaths[order(homeless_deaths$weeknumber),]

write.csv(homeless_deaths, file = "homeless_deaths_datefix.csv")

#### Aggregate by location for the qgis map with varying size circles  ####

homeless_deaths_count <- dcast(homeless_deaths,Lat + Lon ~ 'Count', length,value.var  = 'id')

write.csv(homeless_deaths_count,file='homeless_deaths_count.csv')

#### Make a map ####

## this loops through the dataframe, creating a map for each and outputs it to a png ##

for (i in 1:nrow(homeless_deaths)) { 
  
  homeless_deaths_h <- homeless_deaths %>%
                          slice(1:i-1)
  homeless_deaths_c <- homeless_deaths %>%
                          slice(i)
  wb <- anytime(homeless_deaths_c$weekbeginning)
  
  wb <- format(wb,format="%B %d %Y")
  
  homeless_name <- homeless_deaths_c$Name
  
  map <-  leaflet(options = leafletOptions(zoomControl = FALSE)) %>% 
  addProviderTiles("CartoDB.Positron") %>% 
  setView(-2, 55.3,
          zoom = 5) %>%
  addCircleMarkers(data = homeless_deaths_h, radius = 5, fillColor = 'red', stroke = F ) %>%
  addCircleMarkers(data = homeless_deaths_c, radius = 10, fillColor = 'red', stroke = F, fillOpacity = 1) %>%
  addControl(paste0("<h1>Deaths of Homeless People in 2018</h1>"), position = "topleft") %>%
  addControl(paste0("Data from the Bureau of Investigative Journalism | @northernjamie"), position = "bottomleft") %>%
  addControl(paste0("<h3 style='color:#604c4d'>Week beginning: ",wb,"</h3>"), position = "topleft") %>%
  addControl(paste0("<h2 style='color:#604c4d'>Name: ",homeless_name,"</h2>"), position = "topleft")


saveWidget(map, 'temp.html', selfcontained = FALSE)
webshot('temp.html', file=paste0('Rplotd',i,'.png'),
        cliprect = 'viewport')


}


