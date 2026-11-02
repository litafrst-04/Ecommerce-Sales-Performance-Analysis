# E-Commerce End-to-End Sales Performance and Operations

📌 ##Project Overview

Proyek ini bertujuan untuk menganalisis data transaksi e-commerce secara komprehensif untuk memahami pola perilaku pembelian pelanggan, mengevaluasi tren omset penjualan, serta memantau efisiensi operasional platform secara *end-to-end*. Analisis ini menggabungkan penggunaan **SQL** untuk tahapan audit dan pembersihan data (*data profiling & cleaning*) serta **Microsoft Excel** untuk eksplorasi data lanjutan dan visualisasi *dashboard* interaktif.

🛠️ ## Tools Used

- **SQL:** Digunakan untuk melakukan *data profiling* awal, mendeteksi anomali struktur, menyeragamkan format tanggal, serta membersihkan inkonsistensi data transaksi sebelum diolah.
- **Microsoft Excel:** Digunakan untuk pengolahan data lanjutan melalui *Pivot Tables*, penyusunan *Pivot Charts*, penerapan *Slicers* dan *Timeline*, serta pembangunan *Interactive Sales Dashboard*.

📋 ## Scope of Work & Data Lifecycle

### 1. Pemeriksaan Data (Data Profiling - SQL)

Melakukan audit menyeluruh terhadap dataset transaksi awal untuk mendeteksi potensi masalah kualitas data (`Data Profiling Awal.sql`). Tahap ini mengidentifikasi variasi format penulisan tanggal, anomali teks, serta menemukan adanya *missing values* pada beberapa atribut numerik penting.

### 2. Pembersihan Data (Data Cleaning - SQL)

Melakukan transformasi dan standarisasi data secara sistematis (`Data Cleaning.sql`), yang meliputi:
- **Standarisasi Tanggal:** Menyeragamkan berbagai format penulisan tanggal ke dalam satu format standar yang konsisten.
- **Penanganan Anomali:** Membersihkan karakter asing, spasi tersembunyi, serta merapikan inkonsistensi string pada data kategori dan metode pembayaran.
- **Validasi Struktur:** Memastikan seluruh kolom data bersih dan terstruktur dengan baik, yang diverifikasi kembali melalui tahap akhir (`Data Profiling Akhir.sql`).

### 3. Eksplorasi Data (Data Exploration)

Menggunakan kueri SQL dan Pivot Tables untuk mengolah ringkasan statistik dasar, meliputi:
- Penghitungan total omset bersih (*Total Omset Bersih*), total volume kuantitas produk terjual, jumlah transaksi sukses, serta rata-rata nilai transaksi global.
- Pemetaan performa penjualan berdasarkan kategori produk serta perbandingan penggunaan metode pembayaran.

### 4. Visualisasi Data & Interactive Dashboard

Menerjemahkan hasil analisis ke dalam bentuk visual yang interaktif dan dinamis menggunakan Pivot Charts, *Slicers* (Filter Status, Kategori, dan Metode Pembayaran), serta *Timeline* bulanan. Dashboard ini dirancang agar manajemen dapat dengan mudah membaca metrik bisnis dan menarik kesimpulan strategis secara cepat.

❓ ## Business Questions & Insights

- **Q1:** Kapan periode waktu atau bulan yang mencatatkan lonjakan omset dan volume pesanan tertinggi?
  - *Insight:* Performa penjualan menunjukkan tren fluktuatif dengan lonjakan omset signifikan pada periode tertentu, didukung oleh aktivitas transaksi yang terekam secara dinamis pada *Timeline* bulanan.
- **Q2:** Kategori produk dan metode pembayaran apa saja yang paling mendominasi transaksi keseluruhan?
  - *Insight:* Kategori produk tertentu mencatatkan volume penjualan paling tinggi, sementara metode pembayaran seperti *Cash on Delivery* dan *Bank Transfer* mendominasi preferensi cara bayar pelanggan.
- **Q3:** Bagaimana pengaruh status pesanan terhadap kestabilan omset bersih penjualan?
  - *Insight:* Dari total keseluruhan transaksi, sebagian besar pesanan berhasil dikirim (*Delivered/Shipped*), sementara sisa status seperti *Cancelled* atau *Returned* dapat dipantau langsung dampaknya terhadap perolehan omset bersih melalui filter interaktif.

📁 ## Project Files

- `Data Profiling Awal.sql`: Berisi kueri SQL untuk audit kualitas data mentah.
- `Data Cleaning.sql`: Berisi kueri SQL untuk proses pembersihan dan transformasi data.
- `Data Profiling Akhir.sql`: Berisi kueri SQL untuk verifikasi akhir struktur data.
- `Ecommerce_Sales_Dashboard.xlsx`: File utama Excel yang mencakup data terproses, *Pivot Tables*, hingga *Interactive Sales & Performance Dashboard*.
