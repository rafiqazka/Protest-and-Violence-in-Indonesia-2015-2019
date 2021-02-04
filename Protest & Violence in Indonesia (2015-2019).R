#Input File csv dataset
dataprotes <- read.csv(file.choose(), na.strings ="")

#Library
library("dplyr")


###Pre processing

##Tipe Data

#Cek struktur dari dataprotes
str(dataprotes)

#Ubah tipe data event_date
dataprotes$event_date <- as.Date(dataprotes$event_date, format = "%d-%b-%y")
dataprotes$event_date <- format(dataprotes$event_date, "%d/%m/%Y")
dataprotes$event_date <- as.Date(dataprotes$event_date, format = "%d/%m/%Y")

#Ubah tipe data year
dataprotes$year <- factor(dataprotes$year)

#Cek ulang tipe data year dan event_date
class(dataprotes$year)
class(dataprotes$event_date)


##Duplikasi

#Cek duplicate based on ID
n_occur <- data.frame(table(dataprotes$data_id))
n_occur[n_occur$Freq > 1,]
dataprotes[dataprotes$data_id %in% n_occur$Var1[n_occur$Freq > 1],]

#remove exact duplicate
dataprotes_clean <- distinct(dataprotes, .keep_all=TRUE)

#Re-check duplicate on ID
n2_occur <- data.frame(table(dataprotes_clean$data_id))
n2_occur[n2_occur$Freq > 1,]

#Check Duplicated ID
dataprotes_duplicate <- dataprotes_clean[dataprotes_clean$data_id %in% n2_occur$Var1[n2_occur$Freq > 1],]

#Menghilangkan data yang mengandung "Forces" untuk menghindari duplikasi (agar kolom actor1 seharusnya berisi actor rakyat saja)
dataprotes_clean2 <- dataprotes_clean[!grepl("Forces", dataprotes_clean$actor1),]

#Re-check duplicate on ID
n3_occur <- data.frame(table(dataprotes_clean2$data_id))
n3_occur[n3_occur$Freq > 1,]

#Check Duplicated ID
dataprotes_duplicate2 <- dataprotes_clean2[dataprotes_clean2$data_id %in% n3_occur$Var1[n3_occur$Freq > 1],]

#mengecek derajat missing data pada kolom assoc_actor_1 (adanya missing data di kolom ini diduga penyebab beberapa row tidak terdeteksi duplikat padahal id nya duplikat)
sapply(dataprotes_clean2, function(x) sum(is.na(x)))

#menghapus kolom assoc_actor_1 (karena jumlah missing data nya > 5%)
dataprotes_clean3 <- select(dataprotes_clean2, -c(assoc_actor_1)) 

#menghapus duplicated row setelah kolom assoc_actor_1 dihapus
dataprotes_clean3 <- distinct(dataprotes_clean3, .keep_all=TRUE)

#Re-check duplicate on ID
n4_occur <- data.frame(table(dataprotes_clean3$data_id))
n4_occur[n4_occur$Freq > 1,]

#Check Duplicated ID
dataprotes_duplicate3 <- dataprotes_clean3[dataprotes_clean3$data_id %in% n4_occur$Var1[n4_occur$Freq > 1],]

#menghapus kolom actor1 karena masih terus menjadi penyebab banyaknya duplicated data dan kolom-kolom yang tidak relevan/terkait actor1
dataprotes_clean4 <- dataprotes_clean3[, -c(10:12)]

#menghapus duplicated row setelah kolom actor1 dihapus
dataprotes_fixed <- distinct(dataprotes_clean4, .keep_all=TRUE)

#Re-check duplicate on ID
n5_occur <- data.frame(table(dataprotes_fixed$data_id))
n5_occur[n5_occur$Freq > 1,]


## Pengecekan Missing data setiap kolom
library("DataExplorer")
plot_missing(dataprotes_fixed)

#Karena missing data sudah tidak ada, maka data sudah siap dianalisis dalam bentuk visualisasi



###Visualisasi Data dan Analisis


library(ggplot2)


##Analisis umum

#explore tren tahunan (catatan: tahun 2019 baru sampai januari)
ggplot(dataprotes_fixed, aes(year)) + geom_bar(fill = "navy")+
  labs(x = "Year", y = "Number of event", title = "Jumlah event per tahun")

#explore tren harian
library(scales)
dataprotes_fixed %>% count(event_date) %>% 
  ggplot(aes(event_date, n))+ geom_line(color = "green", size = 0.1)+
  geom_smooth(color = "black") +
  expand_limits(y = 0)+
  labs(title ="Continous Date Pattern", color = "blue")+
  scale_x_date(breaks = date_breaks("1 year"), labels = date_format("%Y"))+
  labs(x = "Date", y = "Number of event", title = "Jumlah event per hari")

#explore event
dataprotes_fixed %>% count(event_type) %>% arrange(-n) %>% head(5) %>%
  ggplot(aes(reorder(event_type,n), n))+
  geom_col(fill = "navy")+
  coord_flip()+
  labs(x = "Event", y = "Frekuensi", title = "Top 5 event terfrekuentif")

#explore sub event
dataprotes_fixed %>% count(sub_event_type) %>% arrange(-n) %>% head(5) %>%
  ggplot(aes(reorder(sub_event_type,n), n))+
  geom_col(fill = "navy")+
  coord_flip()+
  labs(x = "Sub Event", y = "Frekuensi", title = "Top 5 subevent terfrekuentif")

#peta kejadian
library(maps)
library(mapdata)
library(maptools)
library(scales)

map("worldHires","Indonesia", xlim=c(94,142),ylim=c(-11,7.5), col="gray90", fill=TRUE)  #plot the region of Indonesia I want
points(dataprotes_fixed$longitude, dataprotes_fixed$latitude, pch=19, col="red", cex=0.5)

#heat map kejadian
library(ggmap)
library(RColorBrewer)

map_bounds <- c(left = 94, bottom = -11, right = 142, top = 7.5)
coords.map <- get_stamenmap(map_bounds, zoom = 7, maptype = "toner-lite")
coords.map <- ggmap(coords.map, extent="device", legend="none")
coords.map <- coords.map + stat_density2d(data=dataprotes_fixed,  aes(x=longitude, y=latitude, fill=..level.., alpha=..level..), geom="polygon")
coords.map <- coords.map +   scale_fill_gradientn(colours=rev(brewer.pal(7, "Spectral")))
coords.map <- coords.map + theme_bw()
ggsave(filename="./coords.png")

#explore jumlah kejadian per provinsi
dataprotes_fixed %>% count(admin1) %>% arrange(-n) %>% head(5) %>%
  ggplot(aes(reorder(admin1,n), n))+
  geom_col(fill = "navy")+
  coord_flip()+
  labs(x = "Provinsi", y = "Frekuensi", title = "Sebaran provinsi tempat kejadian")

#explore lokasi
dataprotes_fixed %>% count(location) %>% arrange(-n) %>% head(10) %>%
  ggplot(aes(reorder(location,n), n))+
  geom_col(fill = "navy")+
  coord_flip()+
  labs(x = "Lokasi", y = "Frekuensi", title = "Sebaran lokasi kejadian")


##Mengecek korelasi antara jumlah kejadian dan angka pengangguran per provinsi

#input file pengangguran
data_pengangguran <- read.csv(file.choose(), na.strings ="")

str(data_pengangguran)

#menghitung mean
data_pengangguran$Mean <- rowMeans(data_pengangguran[,2:6])
data_pengangguran

#menghapus row Indonesia
pengangguran_fix <- data_pengangguran[-c(35),]
pengangguran_fix

#menghitung frekuensi pada admin1 (provinsi)
as.data.frame(table(dataprotes_fixed$admin1))

#sorting data pengangguran berdasarkan abjad
pengangguran_sorted <- pengangguran_fix[order(pengangguran_fix$Provinsi),]
pengangguran_sorted

#memasukkan frekensi kasus per provinsi
case_num = c(103,24,33,7,46,384,5,39,205,123,242,15,4,2,13,6,15,56,19,12,15,21,27,362,66,56,28,171,35,15,20,8,22,87)
pengangguran_case_merged <- cbind(pengangguran_sorted, case_num)
pengangguran_case_merged

#membuat scatter plot
ggplot(pengangguran_case_merged, aes(x=Mean, y=case_num)) + geom_point() + stat_smooth()

#memeriksa korelasi
library(ggpubr)
ggscatter(pengangguran_case_merged, x = "Mean", y = "case_num", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Tingkat Pengangguran", ylab = "Jumlah Kasus")


##Mengecek korelasi antara jumlah kejadian dan indeks kerukunan beragama per provinsi

#memasukkan indeks kerukunan
religion_index = c(60.2,80.1,68.9,71.8,74.2,71.3,73.2,70.7,68.5,74.6,73.7,76.7,72.5,77.8,73.6,76.3,73.1,72.8,73.1,79.4,72.7,70.4,81.1,79,82.1,69.3,76.7,75.7,75,73.9,79.9,64.4,72.4,76.3)
religion_merged <- cbind(pengangguran_case_merged, religion_index)
religion_merged

#memeriksa korelasi
ggscatter(religion_merged, x = "religion_index", y = "case_num", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Indeks Toleransi Beragama", ylab = "Jumlah Kasus")


##Analisis fatalities

#Explore fatalities by year
ggplot(dataprotes_fixed, aes(x=year, y=fatalities)) + geom_bar(stat = "identity", fill = "navy") +
  labs(x = "Year", y = "Total Fatalities", title = "Total Fatalities per Year")


#fatalities per year per sub event (melihat sub event yang meningkat sehingga mendorong banyaknya fatalities di tahun 2018)
ggplot(dataprotes_fixed, aes(x = year, y = fatalities, color = sub_event_type, size=10))+ geom_point() + 
  labs(x = "Year", y = "Total Fatalities", title = "Total Fatalities per Year per Sub Event")

#lokasi terbanyak suicide bomb
data_suicidebomb <- dataprotes_fixed[dataprotes_fixed$sub_event_type == 'Suicide bomb',]

data_suicidebomb %>% count(location) %>% arrange(-n) %>% head(10) %>%
  ggplot(aes(reorder(location,n), n))+
  geom_col(fill = "navy")+
  coord_flip()+
  labs(x = "Lokasi", y = "Frekuensi", title = "Sebaran lokasi suicide bomb")
