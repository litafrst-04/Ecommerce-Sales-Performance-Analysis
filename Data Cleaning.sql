-- =========================
-- MEMBUAT SALINAN DATA BARU
-- =========================
create table ecommerce_sales_clean as
select *
from ecommerce_sales;

-- Memeriksa Salinan Tabel
select
    'ecommerce_sales' as nama_tabel,
    count(*) as total_baris
from ecommerce_sales
union all
select
    'ecommerce_sales_clean',
    count(*)
from ecommerce_sales_clean;

-- ===========================
-- MEMERIKSA KONDISI AWAL DATA
-- ===========================

-- 2.1. Mencari Missing Value
select 
    sum(
        case
            when id is null then 1
            else 0
        end
    ) as kosong_id,
    sum(
        case
            when customer_name is null
            or trim(customer_name) = ''
            or lower(customer_name) in ('n/a', 'unknown', 'nan') then 1
            else 0
        end
    ) as kosong_customer_name,
    sum(
        case
            when order_id is null 
            or trim(order_id) = ''
            or lower(order_id) in ('n/a', 'unknown', 'nan') then 1
            else 0
        end
    ) as kosong_order_id,
    sum(
        case
            when order_date is null 
            or trim(order_date) = ''
            or lower(order_date) in ('n/a', 'unknown', 'nan') then 1
            else 0
        end
    ) as kosong_order_date,
    sum(
        case
            when product is null
            or trim(product) = ''
            or lower(product) in ('n/a', 'unknown', 'nan') then 1
            else 0
        end
    ) as kosong_product,
    sum(
        case
            when category is null
            or trim(category) = ''
            or lower(category) in ('n/a', 'unknown', 'nan') then 1
            else 0
        end
    ) as kosong_category,
    sum(
        case
            when quantity is null
            or trim(quantity) = ''
            or lower(quantity) in ('n/a', 'unknown', 'nan') then 1
            else 0
        end
    ) as kosong_quantity,
    sum(
        case
            when price is null
            or trim(price) = ''
            or lower(price) in ('n/a', 'unknown','nan') then 1
            else 0
        end
    ) as kosong_price,
    sum(
        case
            when payment_method is null
            or trim(payment_method) = ''
            or lower(payment_method) in ('n/a', 'unknown','nan') then 1
            else 0
        end
    ) as kosong_payment_method,
    sum(
        case
            when status is null
            or trim(status) = ''
            or lower(status) in ('n/a', 'unknown', 'nan') then 1
            else 0
        end
    ) as kosong_status,
    sum(
        case
            when total is null then 1
            else 0
        end
    ) as kosong_total
from ecommerce_sales_clean;

-- 2.2. Memeriksa Tipe Data Awal
select
    column_name,
    data_type
from information_schema.columns
where table_name = 'ecommerce_sales_clean'
order by ordinal_position;

-- ==========================
-- MEMBERSIHKAN DATA KATEGORI
-- ==========================

-- 3.1. Menemukan Kategori Kosong
-- Missing Value pada Kolom Category
select *
from ecommerce_sales_clean
where category is null 
    or trim(category) = ''
    or lower(category) in ('n/a', 'unknown', 'nan');

-- 3.2. Membandingkan Produk dan Kategori yang Tersedia
select 
    product,
    category
from ecommerce_sales_clean 
where product in ('Biography', 'Headphones', 'Laptop', 'Smartphone', 'Shoes', 'Jeans', 'Basketball', 'Vacuum')
order by product;

select 
    product,
    category
from ecommerce_sales_clean 
where product in ('Biography', 'Headphones', 'Laptop', 'Smartphone', 'Shoes', 'Jeans')
    and category is not null
    and trim(category) <> ''
    and lower(category) not in ('n/a', 'unknown', 'nan')
order by product;

select 
    product,
    category
from ecommerce_sales_clean 
where product in ('Biography', 'Headphones', 'Laptop', 'Smartphone', 'Shoes', 'Jeans')
    and (
        category is null
        or trim(category) = ''
        or lower(category) in ('n/a', 'unknown', 'nan')
    );

-- 3.3. Mengisi Kategori Berdasarkan Pola Data
update ecommerce_sales_clean
set category = 'Books'
where product = 'Biography'
    and category = 'nan';

update ecommerce_sales_clean 
set category = 'Electronics'
where product = 'Headphones'
    and trim(category) = '';

update ecommerce_sales_clean 
set category = 'Electronics'
where product = 'Laptop'
    and trim(category) = '';

update ecommerce_sales_clean 
set category = 'Electronics'
where product = 'Smartphone'
    and category = 'nan';

update ecommerce_sales_clean 
set category = 'Clothing'
where product = 'Shoes'
    and trim(category) = '';

update ecommerce_sales_clean 
set category = 'Clothing'
where product = 'Jeans'
    and trim(category) = '';

-- 3.4. Memeriksa Hasil Perbaikan Kategori
select 
    product,
    category
from ecommerce_sales_clean
where product in ('Biography', 'Headphones', 'Laptop', 'Smartphone', 'Shoes', 'Jeans')
order by product;

-- =====================================================
-- MEMERIKSA DAN MEMBERSIHKAN QUANTITY, PRICE, DAN TOTAL
-- =====================================================

-- 4.1. Menemukan Missing Value
--- Missing Value pada Kolom Quantity
select *
from ecommerce_sales_clean
where quantity is null 
    or trim(quantity) = ''
    or lower(quantity) in ('n/a', 'unknown', 'nan');

--- Missing Value pada Kolom Price
select *
from ecommerce_sales_clean
where price is null 
    or trim(price) = ''
    or lower(price) in ('n/a', 'unknown', 'nan');

--- Missing Value pada Kolom Total
select *
from ecommerce_sales_clean
where total is null;

-- 4.2. Melihat Pola Hubungan Quantity, Price, dan Total
select
    id, 
    quantity, 
    price, 
    total
from ecommerce_sales_clean 
where quantity is not null
    and price is not null 
    and total is not null;

select 
    id, 
    quantity,
    price,
    total,
    round(quantity::int * price::numeric, 2) as hasil_perkalian,
    round(total::numeric, 2) as pembulatan_total,
    case 
        when round(quantity::int * price::numeric, 2) = round(total::numeric, 2) then 'cocok'
        else 'tidak cocok'
    end as pemeriksaan_pola
from ecommerce_sales_clean
where quantity is not null
    and price is not null 
    and total is not null
    and quantity ~ '^[0-9]+$'
    and price ~ '^[0-9]+(\.[0-9]+)?$';

-- 4.3. Menemukan Quantity yang Tidak Valid
select id, quantity
from ecommerce_sales_clean
where quantity is null
   or trim(quantity) = ''
   or quantity !~ '^-?[0-9]+$';

select id, quantity
from ecommerce_sales_clean
where quantity ~ '^-[0-9]+$';

select id, product, quantity, price, total
from ecommerce_sales_clean
where quantity is null
   or trim(quantity) = ''
   or quantity !~ '^[0-9]+$'
order by id;

-- 4.4. Menemukan Price yang Tidak Valid
select id, price
from ecommerce_sales_clean
where price is null
   or trim(price) = ''
   or price !~ '^[0-9]+(\.[0-9]+)?$';

select id, product, quantity, price, total
from ecommerce_sales_clean
where price ~ '^-[0-9]+(\.[0-9]+)?$';

-- 4.5. Memperbaiki Format Price yang Tidak Konsisten
update ecommerce_sales_clean
set price = '300'
where id = 120
  and price = '300$';

select id, product, price
from ecommerce_sales_clean
where id = 120;

update ecommerce_sales_clean
set price = '400'
where id = 110
  and price = 'four hundred';

select id, product, quantity, price, total
from ecommerce_sales_clean
where id = 110;

-- 4.6. Menangani Price yang Tidak Dapat Dipastikan
update ecommerce_sales_clean
set price = null
where id in (101, 196)
  and price = 'abd';

select id, product, quantity, price, total
from ecommerce_sales_clean
where id in (101, 116, 124, 130, 156, 183, 196)
order by id;

select id, price
from ecommerce_sales_clean
where price is not null
  and (
      trim(price) = ''
      or price !~ '^[0-9]+(\.[0-9]+)?$'
  );

-- 4.7. Memeriksa Data Price dan Quantity Sebelum Konversi Tipe
select
    id,
    quantity,
    price
from ecommerce_sales_clean
where (quantity is not null and trim(quantity) <> ''
       and quantity !~ '^-?[0-9]+$')
   or (price is not null and trim(price) <> ''
       and price !~ '^[0-9]+(\.[0-9]+)?$');

-- 4.8. Menangani Quantity yang Tidak Valid
update ecommerce_sales_clean
set quantity = null
where id = 192
  and quantity = '4a';

select id, quantity
from ecommerce_sales_clean
where quantity is not null
  and (
      trim(quantity) = ''
      or quantity !~ '^-?[0-9]+$'
      or quantity::numeric < 0
  );

-- 4.9. Memeriksa Total yang Kosong
select id, product, quantity, price, total
from ecommerce_sales_clean
where total is null
order by id;

select id, quantity, price, total
from ecommerce_sales_clean
where total is null
  and quantity ~ '^[0-9]+$'
  and price ~ '^[0-9]+(\.[0-9]+)?$';

-- 4.10. Memperbaiki Total Berdasarkan Nilai yang Diketahui
update ecommerce_sales_clean
set total = case
    when id = 110 then 2000
    when id = 120 then 1500
end
where id in (110, 120)
  and total is null;

-- 4.11. Memeriksa Total Berdasarkan Harga Produk
select
    product,
    count(*) as jumlah_transaksi,
    count(price) as jumlah_harga_tersedia,
    min(price) as harga_minimum,
    max(price) as harga_maksimum
from ecommerce_sales_clean
group by product
order by product;

-- =================================
-- MEMERIKSA DAN MEMPERBAIKI TANGGAL
-- =================================

-- 5.1. Memeriksa Format Tanggal Sebelum Konversi
select id, order_date
from ecommerce_sales_clean
where order_date is not null
  and trim(order_date) <> ''
  and trim(order_date) !~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

-- 5.2. Menangani Tanggal yang Tidak Valid
update ecommerce_sales_clean
set order_date = null
where id = 192
  and order_date = 'abc';

-- 5.3. Memeriksa Tanggal yang Masih Tersedia
select
    id,
    order_date
from ecommerce_sales_clean
where order_date is not null
  and trim(order_date) <> ''
order by id;

-- ==========================
-- MENYAMAKAN TIPE DATA KOLOM
-- ==========================

-- 6.1. Mengubah Tipe Data Tanggal
alter table ecommerce_sales_clean
alter column order_date type date
using case
    when order_date is null or trim(order_date) = '' then null
    when order_date ~ '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
        then to_date(order_date, 'MM/DD/YYYY')
    when order_date ~ '^[A-Za-z]{3} [0-9]{1,2} [0-9]{4}$'
        then to_date(order_date, 'Mon DD YYYY')
    else null
end;

-- 6.2. Mengubah Tipe Data Quantity
alter table ecommerce_sales_clean
alter column quantity type integer
using nullif(trim(quantity), '')::integer;

-- 6.3. Mengubah Tipe Data Price
alter table ecommerce_sales_clean
alter column price type numeric(10,2)
using nullif(trim(price), '')::numeric;

-- 6.4. Mengubah Tipe Data Total
alter table ecommerce_sales_clean
alter column total type numeric(12,2)
using round(total::numeric, 2);

-- 6.5. Memeriksa Tipe Data Setelah Konversi
select column_name, data_type
from information_schema.columns
where table_name = 'ecommerce_sales_clean'
  and column_name in ('quantity', 'price', 'total')
order by column_name;

-- ================================================
-- MEMPERBAIKI TOTAL BERDASARKAN QUANTITY DAN PRICE
-- ================================================

-- 7.1. Menghitung Ulang Total pada ID Tertentu
update ecommerce_sales_clean
set total = round(quantity * price, 2)
where id in (115, 142, 151, 175, 185)
  and quantity is not null
  and price is not null;

update ecommerce_sales_clean
set total = round(quantity * price, 2)
where (id = 115 and total = 1115.58)
   or (id = 142 and total = 2258.41)
   or (id = 151 and total = 640.02)
   or (id = 175 and total = 77.95)
   or (id = 185 and total = 1023.29);

-- 7.2. Memeriksa Kesesuaian Total
select
    id,
    product,
    quantity,
    price,
    total,
    round(quantity * price, 2) as calculated_total
from ecommerce_sales_clean
where quantity is not null
  and price is not null
  and total is not null
  and round(quantity * price, 2) <> round(total, 2)
order by id;

-- 7.3. Mengisi Total yang Kosong Jika Quantity dan Price Tersedia
update ecommerce_sales_clean
set total = round(quantity * price, 2)
where total is null
  and quantity is not null
  and price is not null;

-- 7.4. Memeriksa Konsistensi Total Sekali Lagi
select
    id,
    quantity,
    price,
    total,
    round(quantity * price, 2) as calculated_total
from ecommerce_sales_clean
where
    (total is not null
     and quantity is not null
     and price is not null
     and total <> round(quantity * price, 2))
    or
    (total is null
     and quantity is not null
     and price is not null)
order by id;

-- =======================
-- MENANGANI NILAI NEGATIF
-- =======================

-- 8.1. Menemukan Nilai Negatif
select id, product, quantity, price, total
from ecommerce_sales_clean
where quantity < 0
   or price < 0
   or total < 0
order by id;

-- 8.2. Memperbaiki Nilai Negatif yang Sudah Dikonfirmasi
update ecommerce_sales_clean
set quantity = abs(quantity),
    total = abs(total)
where id in (117, 134);

select id, product, quantity, price, total
from ecommerce_sales_clean
where id in (117, 134);

-- 8.3. Memperbaiki Nilai Negatif pada ID 137
update ecommerce_sales_clean
set price = 100,
    total = 300
where id = 137
  and price = -100
  and total = -300;

select id, product, quantity, price, total
from ecommerce_sales_clean
where id = 137;

-- ==================
-- MENANGANI DUPLIKAT
-- ==================

-- 9.1. Memeriksa Baris yang Terindikasi Duplikat
select *
from ecommerce_sales_clean
where id in (142, 146, 175)
order by id;

-- 9.2. Menghapus Duplikat Berdasarkan Pemeriksaan Sebelumnya
delete from ecommerce_sales_clean a
using ecommerce_sales_clean b
where a.id = b.id
  and a.ctid > b.ctid
  and a.id in (142, 146, 175);

-- 9.3. Memastikan ID yang Diperiksa Tidak Lagi Ganda
select id, count(*) as jumlah_baris
from ecommerce_sales_clean
where id in (142, 146, 175)
group by id
order by id;

-- 9.4. Memeriksa Keunikan Order ID
select
    order_id,
    count(*) as jumlah_baris
from ecommerce_sales_clean
group by order_id
having count(*) > 1
order by jumlah_baris desc;

-- ======================================
-- MENSTANDARKAN KATEGORI DAN NAMA PRODUK
-- ======================================

-- 10.1. Memeriksa Variasi Kategori
select distinct category
from ecommerce_sales_clean
order by category;

-- 10.2. Menstandarkan Penulisan Kategori
update ecommerce_sales_clean
set category = case
    when lower(trim(category)) in ('electronic', 'electronics')
        then 'Electronics'
    when lower(trim(category)) = 'sports'
        then 'Sports'
    else trim(category)
end
where category is not null;

-- 10.3. Memeriksa Metode Pembayaran dan Status
select distinct payment_method
from ecommerce_sales_clean
order by payment_method;

select distinct status
from ecommerce_sales_clean
order by status;

-- 10.4. Menstandarkan Nama Produk
update ecommerce_sales_clean
set product = 'Shoes'
where product = 'shoes';

-- 10.5. Memeriksa Spasi di Awal dan Akhir Teks
select
    id,
    customer_name,
    order_id,
    product,
    category,
    payment_method,
    status
from ecommerce_sales_clean
where
    customer_name <> trim(customer_name)
    or order_id <> trim(order_id)
    or product <> trim(product)
    or category <> trim(category)
    or payment_method <> trim(payment_method)
    or status <> trim(status)
order by id;

-- 10.6. Memeriksa Konsistensi Nilai Kategori, Metode Pembayaran, dan Status
select 'category' as nama_kolom, category as nilai, count(*) as jumlah
from ecommerce_sales_clean
group by category
union all
select 'payment_method', payment_method, count(*)
from ecommerce_sales_clean
group by payment_method
union all
select 'status', status, count(*)
from ecommerce_sales_clean
group by status
order by nama_kolom, nilai;

-- ====================================================
-- MENELUSURI MISSING VALUE YANG BELUM DAPAT DIPASTIKAN
-- ====================================================

-- 11.1. Memeriksa Kategori Kosong
select id, product, category
from ecommerce_sales_clean
where category is null
   or trim(category) = ''
order by id;

-- 11.2. Memeriksa Kategori Produk yang Sama
select id, product, category
from ecommerce_sales_clean
where product ilike '%vacuum%'
order by id;

select id, product, category
from ecommerce_sales_clean
where product ilike '%basketball%'
order by id;

-- 11.3. Mengisi Kategori Basketball
update ecommerce_sales_clean
set category = 'Sports'
where id = 193
  and product = 'Basketball'
  and (category is null or trim(category) = '');

-- 11.4. Mengisi Kategori Vacuum Berdasarkan Pola Mayoritas
update ecommerce_sales_clean
set category = 'Home'
where id = 198
  and product = 'Vacuum'
  and (category is null or trim(category) = '');

-- 11.5. Memastikan Kategori Sudah Tidak Kosong
select id, product, category
from ecommerce_sales_clean
where category is null
   or trim(category) = '';

-- 11.6. Memeriksa Missing Value pada Quantity
select id, product, quantity, price, total
from ecommerce_sales_clean
where quantity is null
order by id;

-- 11.7. Memeriksa Missing Value pada Price
select id, price
from ecommerce_sales_clean
where price is null;

-- 11.8. Membandingkan Nilai Kosong dengan Tabel Sumber
select
    c.id,
    c.order_id,
    c.product,
    c.quantity as quantity_clean,
    s.quantity as quantity_source,
    c.price as price_clean,
    s.price as price_source,
    c.total as total_clean,
    s.total as total_source
from ecommerce_sales_clean c
join ecommerce_sales s
    on c.id = s.id
where c.total is null
order by c.id;

select *
from ecommerce_sales
where id in (101, 106, 116, 124, 130, 156,
             164, 167, 183, 192, 193, 196)
order by id;

-- 11.9. Memeriksa Total yang Masih Kosong
select
    id,
    order_id,
    product,
    quantity,
    price,
    total
from ecommerce_sales_clean
where total is null
order by id;

-- ===============================
-- PEMERIKSAAN AKHIR DATA CLEANING
-- ===============================

-- 12.1. Memeriksa Jumlah Baris, Keunikan ID, dan Missing Value
select
    count(*) as total_baris,
    count(distinct id) as id_unik,
    count(distinct order_id) as order_id_unik,
    count(*) filter (where order_date is null) as tanggal_kosong,
    count(*) filter (where category is null) as kategori_kosong,
    count(*) filter (where quantity is null) as quantity_kosong,
    count(*) filter (where price is null) as price_kosong,
    count(*) filter (where total is null) as total_kosong,
    count(*) filter (where quantity < 0 or price < 0 or total < 0) as nilai_negatif
from ecommerce_sales_clean;

-- 12.2. Memeriksa Nilai Nol dan Negatif
select
    count(*) filter (where quantity < 0) as quantity_negatif,
    count(*) filter (where price < 0) as price_negatif,
    count(*) filter (where total < 0) as total_negatif,
    count(*) filter (where quantity = 0) as quantity_nol,
    count(*) filter (where price = 0) as price_nol,
    count(*) filter (where total = 0) as total_nol
from ecommerce_sales_clean;

-- 12.3. Memeriksa Baris dengan Tanggal atau Kategori Kosong
select id, order_date, product, category
from ecommerce_sales_clean
where category is null
   or trim(category) = ''
   or order_date is null
order by id;
