-- ===========================
-- 1. STRUKTUR DAN UKURAN DATA
-- ===========================

--- Memeriksa jumlah baris pada tabel bersih
select
    count(*) as total_baris
from ecommerce_sales_clean;

--- Memeriksa jumlah kolom pada tabel bersih
select
    count(*) as total_kolom
from information_schema.columns
where table_schema = 'public'
  and table_name = 'ecommerce_sales_clean';

--- Membandingkan jumlah baris sebelum dan sesudah cleaning
select
    (select count(*) from ecommerce_sales) as total_baris_mentah,
    (select count(*) from ecommerce_sales_clean) as total_baris_bersih;

--- Memeriksa rentang ID
select
    min(id) as id_minimum,
    max(id) as id_maksimum,
    count(id) as jumlah_id_terisi
from ecommerce_sales_clean;


-- ========================
-- 2. ANATOMI DAN TIPE DATA
-- ========================

--- Memeriksa nama kolom dan tipe data setelah cleaning
select
    column_name,
    data_type,
    is_nullable
from information_schema.columns
where table_schema = 'public'
  and table_name = 'ecommerce_sales_clean'
order by ordinal_position;

--- Membandingkan tipe data tabel mentah dan tabel bersih
select
    table_name,
    column_name,
    data_type
from information_schema.columns
where table_schema = 'public'
  and table_name in ('ecommerce_sales', 'ecommerce_sales_clean')
order by
    column_name,
    table_name;


-- ===================
-- 3. KELENGKAPAN DATA
-- ===================

--- Memeriksa jumlah nilai kosong pada setiap kolom
select
    'id' as nama_kolom,
    count(*) filter (where id is null) as jumlah_kosong
from ecommerce_sales_clean
union all
select
    'customer_name',
    count(*) filter (
        where nullif(trim(customer_name), '') is null
           or lower(trim(customer_name)) in ('nan', 'n/a', 'unknown')
    )
from ecommerce_sales_clean
union all
select
    'order_id',
    count(*) filter (
        where nullif(trim(order_id), '') is null
           or lower(trim(order_id)) in ('nan', 'n/a', 'unknown')
    )
from ecommerce_sales_clean
union all
select
    'order_date',
    count(*) filter (where order_date is null)
from ecommerce_sales_clean
union all
select
    'product',
    count(*) filter (
        where nullif(trim(product), '') is null
           or lower(trim(product)) in ('nan', 'n/a', 'unknown')
    )
from ecommerce_sales_clean
union all
select
    'category',
    count(*) filter (
        where nullif(trim(category), '') is null
           or lower(trim(category)) in ('nan', 'n/a', 'unknown')
    )
from ecommerce_sales_clean
union all
select
    'quantity',
    count(*) filter (where quantity is null)
from ecommerce_sales_clean
union all
select
    'price',
    count(*) filter (where price is null)
from ecommerce_sales_clean
union all
select
    'payment_method',
    count(*) filter (
        where nullif(trim(payment_method), '') is null
           or lower(trim(payment_method)) in ('nan', 'n/a', 'unknown')
    )
from ecommerce_sales_clean
union all
select
    'status',
    count(*) filter (
        where nullif(trim(status), '') is null
           or lower(trim(status)) in ('nan', 'n/a', 'unknown')
    )
from ecommerce_sales_clean
union all
select
    'total',
    count(*) filter (where total is null)
from ecommerce_sales_clean
order by nama_kolom;


-- ====================
-- 4. KEUNIKAN DAN DUPLIKASI DATA
-- ====================

--- Memeriksa jumlah ID unik
select
    count(*) as total_baris,
    count(id) as jumlah_id_terisi,
    count(distinct id) as jumlah_id_unik
from ecommerce_sales_clean;

--- Memeriksa ID yang duplikat
select
    id,
    count(*) as jumlah_kemunculan
from ecommerce_sales_clean
group by id
having count(*) > 1
order by id;

--- Memeriksa order_id yang digunakan lebih dari sekali
select
    order_id,
    count(*) as jumlah_kemunculan
from ecommerce_sales_clean
where nullif(trim(order_id), '') is not null
group by order_id
having count(*) > 1
order by jumlah_kemunculan desc, order_id;

--- Memeriksa duplikasi seluruh baris
select
    id,
    customer_name,
    order_id,
    order_date,
    product,
    category,
    quantity,
    price,
    payment_method,
    status,
    total,
    count(*) as jumlah_kemunculan
from ecommerce_sales_clean
group by
    id,
    customer_name,
    order_id,
    order_date,
    product,
    category,
    quantity,
    price,
    payment_method,
    status,
    total
having count(*) > 1
order by id;


-- ====================
-- 5. DISTRIBUSI NILAI DATA
-- ====================

--- Memeriksa distribusi customer_name
select
    customer_name,
    count(*) as jumlah
from ecommerce_sales_clean
group by customer_name
order by jumlah desc, customer_name;

--- Memeriksa distribusi product
select
    product,
    count(*) as jumlah
from ecommerce_sales_clean
group by product
order by jumlah desc, product;

--- Memeriksa distribusi category
select
    category,
    count(*) as jumlah
from ecommerce_sales_clean
group by category
order by jumlah desc, category;

--- Memeriksa distribusi payment_method
select
    payment_method,
    count(*) as jumlah
from ecommerce_sales_clean
group by payment_method
order by jumlah desc, payment_method;

--- Memeriksa distribusi status
select
    status,
    count(*) as jumlah
from ecommerce_sales_clean
group by status
order by jumlah desc, status;

--- Memeriksa distribusi quantity
select
    quantity,
    count(*) as jumlah
from ecommerce_sales_clean
group by quantity
order by quantity;

--- Memeriksa distribusi price
select
    price,
    count(*) as jumlah
from ecommerce_sales_clean
group by price
order by price;

--- Memeriksa distribusi tanggal pesanan
select
    order_date,
    count(*) as jumlah_pesanan
from ecommerce_sales_clean
group by order_date
order by order_date;


-- ====================
-- 6. KUALITAS DAN ANOMALI DATA
-- ====================

--- Memeriksa ID kosong atau negatif
select
    id
from ecommerce_sales_clean
where id is null
   or id < 0
order by id;

--- Memeriksa variasi penulisan category
select
    lower(trim(category)) as kategori_normalisasi,
    count(distinct category) as variasi_penulisan,
    count(*) as jumlah_baris
from ecommerce_sales_clean
where nullif(trim(category), '') is not null
group by lower(trim(category))
having count(distinct category) > 1
order by kategori_normalisasi;

--- Memeriksa variasi penulisan product
select
    lower(trim(product)) as produk_normalisasi,
    count(distinct product) as variasi_penulisan,
    count(*) as jumlah_baris
from ecommerce_sales_clean
where nullif(trim(product), '') is not null
group by lower(trim(product))
having count(distinct product) > 1
order by produk_normalisasi;

--- Memeriksa variasi penulisan payment_method
select
    lower(trim(payment_method)) as metode_normalisasi,
    count(distinct payment_method) as variasi_penulisan,
    count(*) as jumlah_baris
from ecommerce_sales_clean
where nullif(trim(payment_method), '') is not null
group by lower(trim(payment_method))
having count(distinct payment_method) > 1
order by metode_normalisasi;

--- Memeriksa variasi penulisan status
select
    lower(trim(status)) as status_normalisasi,
    count(distinct status) as variasi_penulisan,
    count(*) as jumlah_baris
from ecommerce_sales_clean
where nullif(trim(status), '') is not null
group by lower(trim(status))
having count(distinct status) > 1
order by status_normalisasi;

--- Memeriksa quantity nol atau negatif
select
    id,
    quantity
from ecommerce_sales_clean
where quantity <= 0
order by id;

--- Memeriksa price negatif atau nol
select
    id,
    price
from ecommerce_sales_clean
where price <= 0
order by id;

--- Memeriksa total negatif atau nol
select
    id,
    quantity,
    price,
    total
from ecommerce_sales_clean
where total <= 0
order by id;

--- Memeriksa rentang nilai numerik
select
    min(quantity) as quantity_minimum,
    max(quantity) as quantity_maksimum,
    min(price) as price_minimum,
    max(price) as price_maksimum,
    min(total) as total_minimum,
    max(total) as total_maksimum
from ecommerce_sales_clean;


-- ====================
-- 7. KONSISTENSI ANTARKOLOM
-- ====================

--- Memeriksa kesesuaian quantity, price, dan total
select
    id,
    quantity,
    price,
    total,
    round(quantity * price, 2) as total_hasil_hitung
from ecommerce_sales_clean
where quantity is not null
  and price is not null
  and total is not null
  and round(quantity * price, 2) <> round(total, 2)
order by id;

--- Memeriksa baris yang belum dapat divalidasi karena nilai kosong
select
    id,
    quantity,
    price,
    total
from ecommerce_sales_clean
where quantity is null
   or price is null
   or total is null
order by id;

--- Memeriksa total yang kosong meskipun quantity dan price tersedia
select
    id,
    quantity,
    price,
    total,
    round(quantity * price, 2) as total_hasil_hitung
from ecommerce_sales_clean
where quantity is not null
  and price is not null
  and total is null
order by id;


-- ====================
-- 8. PEMERIKSAAN TANGGAL
-- ====================

--- Memeriksa tanggal kosong
select
    id,
    order_date
from ecommerce_sales_clean
where order_date is null
order by id;

--- Memeriksa rentang tanggal pesanan
select
    min(order_date) as tanggal_terawal,
    max(order_date) as tanggal_terakhir,
    count(order_date) as jumlah_tanggal_terisi
from ecommerce_sales_clean;

--- Memeriksa distribusi pesanan berdasarkan tanggal
select
    order_date,
    count(*) as jumlah_pesanan
from ecommerce_sales_clean
where order_date is not null
group by order_date
order by order_date;


-- ====================
-- 9. VALIDASI HASIL CLEANING
-- ====================

--- Memeriksa placeholder yang tersisa pada kolom kategorikal
select
    id,
    customer_name,
    product,
    category,
    payment_method,
    status
from ecommerce_sales_clean
where lower(trim(coalesce(customer_name, ''))) in ('n/a', 'unknown', 'nan')
   or lower(trim(coalesce(product, ''))) in ('n/a', 'unknown', 'nan')
   or lower(trim(coalesce(category, ''))) in ('n/a', 'unknown', 'nan')
   or lower(trim(coalesce(payment_method, ''))) in ('n/a', 'unknown', 'nan')
   or lower(trim(coalesce(status, ''))) in ('n/a', 'unknown', 'nan')
order by id;

--- Memeriksa spasi berlebih pada kolom kategorikal
select
    id,
    customer_name,
    product,
    category,
    payment_method,
    status
from ecommerce_sales_clean
where customer_name <> trim(customer_name)
   or product <> trim(product)
   or category <> trim(category)
   or payment_method <> trim(payment_method)
   or status <> trim(status)
order by id;

--- Membandingkan jumlah nilai kosong sebelum dan sesudah cleaning
select
    'quantity' as nama_kolom,
    (select count(*) from ecommerce_sales
     where quantity is null
        or nullif(trim(quantity::text), '') is null) as kosong_mentah,
    (select count(*) from ecommerce_sales_clean
     where quantity is null) as kosong_bersih
union all
select
    'price',
    (select count(*) from ecommerce_sales
     where price is null
        or nullif(trim(price::text), '') is null),
    (select count(*) from ecommerce_sales_clean
     where price is null)
union all
select
    'total',
    (select count(*) from ecommerce_sales
     where total is null),
    (select count(*) from ecommerce_sales_clean
     where total is null)
order by nama_kolom;

--- Memastikan jumlah baris tetap sama
select
    (select count(*) from ecommerce_sales) as total_baris_mentah,
    (select count(*) from ecommerce_sales_clean) as total_baris_bersih,
    case
        when (select count(*) from ecommerce_sales)
           = (select count(*) from ecommerce_sales_clean)
        then 'Jumlah baris sama'
        else 'Jumlah baris berbeda'
    end as hasil_validasi;
