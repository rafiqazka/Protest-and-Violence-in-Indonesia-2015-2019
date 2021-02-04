# Protest and Violence in Indonesia (2015-2019) // dengan menggunakan Software R

Oleh: Athollah Iqbal S. (14417006), M. Naufal F. Sahab (14417021), Faris Maulana A. (14417036), dan Dhiya’ Rafiq A. (14417044) dalam rangka menyelesaikan tugas UTS mata kuliah Data Science and Machine Learning (MR4103)

## Latar Belakang
Feeling safe is one important factor that everybody needs. Protest and violence is some factors that can cause fear and loss for the society. There are many types of protest and violence that happens in Indonesia. It is important to identify, map, and collect insight from historical data to deeply understand the real situation is.

## Struktur Data
Data diambil dari [Kaggle](https://www.kaggle.com/aankasman/acled-protests-violence-in-indonesia-20152019) yang berisi data-data protes dan/atau kekerasan pada seluruh negara di ASEAN. Terdapat 3121 data terkait protes dan/atau kekerasan yang memiliki 28 variabel pada dataset-nya.

```
Deskripsi variabel

data_id: Identifier data
iso: Kode numerik untuk setiap negara
event_id_cnty: Identifier sebuah event berdasarkan angka dan akronim negara
event_date: Tanggal kejadian event
year: Tahun terjadinya event 
time_precision: Kode numerik yang mengindikasikan tingkat kepastian dari kode tanggal terjadinya event tersebut 
event_type: Tipe event
sub_event_type: Tipe sub-event
actor1: Aktor yang terlibat pada event
assoc_actor_1: Nama aktor yang terasosiasi atau teridentifikasi dengan actor1 pada suatu event
inter1: Kode numerik yang mengindikasikan tipe actor1
interaction: Kode numerik yang mengindikasikan interaksi antara actor1 dan actor2
region: Wilayah terjadinya event
country: Negara tempat terjadinya event
admin1: Daerah administrasi terbesar dari tempat terjadinya event
admin2: Daerah administrasi terbesar kedua dari tempat terjadinya event
admin3: Daerah administrasi terbesar ketiga dari tempat terjadinya event
location: Lokasi tempat terjadinya event
latitude: Koordinat terjadinya event (latitude)
longitude: Koordinat terjadinya event (longitude)
geo_precision: Kode numerikal yang mengindikasikan tingkat kepastian dari kode koordinat terjadinya event tersebut 
source: Sumber yang melaporkan event
source_scale: Skala geografis dari sumber untuk mengkodifikasi event
notes: Deskripsi singkat dari event
fatalities: Jumlah atau estimasi korban jiwa dari event 
timestamp: Timestamp
iso3: Kode iso CC

```

Untuk mencari korelasi terkait adanya protes dan/atau kekerasan di Indonesia, digunakan data [Tingkat Pengangguran Menurut Provinsi](https://www.bps.go.id/dynamictable/2020/02/19/1774/tingkat-pengangguran-terbuka-tpt-menurut-provinsi-1986---2019.html) dan [Indeks Toleransi Beragama](https://tirto.id/daftar-skor-indeks-kerukunan-beragama-versi-kemenag-2019-engH)


## Hasil
Hasil dari pengolahan data terkait protes dan kekerasan di Indonesia adalah:
+ Jumlah korban jiwa terbesar terjadi pada tahun 2018
+ Korban jiwa terbesar terjadi pada event yang ada di daerah Surabaya
+ Event yang paling banyak terjadi adalah protes dan sub-event yang paling banyak terjadi adalah peaceful protest
+ Berdasarkan heatmap, event paling banyak terjadi di Pulau Jawa, secara khusus di daerah Jakarta dan sekitarnya (Jawa Barat, Banten)
+ Korelasi antara jumlah kasus dan tingkat pengangguran pada suatu provinsi tidak signifikan
+ Korelasi antara jumlah kasus dan indeks toleransi beragama pada suatu provinsi tidak signifikan

Dari hasil tersebut, terdapat beberapa usulan untuk pemerintah, yaitu:
+ Melakukan pencegahan terhadap bom bunuh diri karena memakan korban jiwa yang sangat banyak
+ Meningkatkan kesadaran akan potensi protes dan kekerasan di daerah Jakarta dan Papua (terutama terkait pengiriman pasukan anti huru-hara atau militer) karena kasus protes atau kekerasan di sana tidak berkorelasi dengan faktor ekonomi dan agama
