-- =========================
-- STRUKTUR DAN UKURAN DATA
-- =========================

--- Menghitung total baris
select count(*) as total_baris
from ecommerce_sales;


--- Menghitung total kolom
select count(column_name) as total_kolom
from information_schema.columns
where table_name = 'ecommerce_sales';


-- =========================
-- ANATOMI DAN TIPE DATA
-- =========================

--- Memeriksa nama kolom dan tipe data
select
    column_name,
    data_type
from information_schema.columns
where table_name = 'ecommerce_sales'
order by ordinal_position;


-- =========================
-- KELENGKAPAN DATA
-- =========================

--- Menghitung missing value dan placeholder
select
    count(*) filter (
        where id is null
    ) as kosong_id,
    count(*) filter (
        where customer_name is null
           or trim(customer_name) = ''
           or lower(trim(customer_name)) in ('n/a', 'unknown', 'nan')
    ) as kosong_customer_name,
    count(*) filter (
        where order_id is null
           or trim(order_id) = ''
           or lower(trim(order_id)) in ('n/a', 'unknown', 'nan')
    ) as kosong_order_id,
    count(*) filter (
        where order_date is null
           or trim(order_date) = ''
           or lower(trim(order_date)) in ('n/a', 'unknown', 'nan')
    ) as kosong_order_date,
    count(*) filter (
        where product is null
           or trim(product) = ''
           or lower(trim(product)) in ('n/a', 'unknown', 'nan')
    ) as kosong_product,
    count(*) filter (
        where category is null
           or trim(category) = ''
           or lower(trim(category)) in ('n/a', 'unknown', 'nan')
    ) as kosong_category,
    count(*) filter (
        where quantity is null
           or trim(quantity) = ''
           or lower(trim(quantity)) in ('n/a', 'unknown', 'nan')
    ) as kosong_quantity,
    count(*) filter (
        where price is null
           or trim(price) = ''
           or lower(trim(price)) in ('n/a', 'unknown', 'nan')
    ) as kosong_price,
    count(*) filter (
        where payment_method is null
           or trim(payment_method) = ''
           or lower(trim(payment_method)) in ('n/a', 'unknown', 'nan')
    ) as kosong_payment_method,
    count(*) filter (
        where status is null
           or trim(status) = ''
           or lower(trim(status)) in ('n/a', 'unknown', 'nan')
    ) as kosong_status,
    count(*) filter (
        where total is null
    ) as kosong_total
from ecommerce_sales;


-- =========================
-- KEUNIKAN DAN DUPLIKASI DATA
-- =========================

--- Menghitung jumlah nilai unik setiap kolom
select
    count(distinct id) as id_unik,
    count(distinct customer_name) as customer_name_unik,
    count(distinct order_id) as order_id_unik,
    count(distinct order_date) as order_date_unik,
    count(distinct product) as product_unik,
    count(distinct category) as category_unik,
    count(distinct quantity) as quantity_unik,
    count(distinct price) as price_unik,
    count(distinct payment_method) as payment_method_unik,
    count(distinct status) as status_unik,
    count(distinct total) as total_unik
from ecommerce_sales;


--- Menemukan ID yang berulang
select
    id,
    count(*) as banyak_data
from ecommerce_sales
group by id
having count(*) > 1
order by id;


--- Menemukan order ID yang berulang
select
    order_id,
    count(*) as banyak_data
from ecommerce_sales
group by order_id
having count(*) > 1
order by order_id;


--- Menemukan baris duplikat secara keseluruhan
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
    count(*) as banyak_duplikat
from ecommerce_sales
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


-- =========================
-- DISTRIBUSI NILAI DATA
-- =========================

--- Menghitung frekuensi setiap nilai pada seluruh kolom
select
    'ID' as nama_kolom,
    id::text as data_unik,
    count(*) as banyak_data
from ecommerce_sales
group by id
union all
select
    'CUSTOMER NAME',
    customer_name,
    count(*)
from ecommerce_sales
group by customer_name
union all
select
    'ORDER ID',
    order_id,
    count(*)
from ecommerce_sales
group by order_id
union all
select
    'ORDER DATE',
    order_date,
    count(*)
from ecommerce_sales
group by order_date
union all
select
    'PRODUCT',
    product,
    count(*)
from ecommerce_sales
group by product
union all
select
    'CATEGORY',
    category,
    count(*)
from ecommerce_sales
group by category
union all
select
    'QUANTITY',
    quantity,
    count(*)
from ecommerce_sales
group by quantity
union all
select
    'PRICE',
    price,
    count(*)
from ecommerce_sales
group by price
union all
select
    'PAYMENT METHOD',
    payment_method,
    count(*)
from ecommerce_sales
group by payment_method
union all
select
    'STATUS',
    status,
    count(*)
from ecommerce_sales
group by status
union all
select
    'TOTAL',
    total::text,
    count(*)
from ecommerce_sales
group by total
order by nama_kolom asc, data_unik asc;


-- =========================
-- KUALITAS DAN ANOMALI DATA
-- =========================

--- Memeriksa ID yang tidak valid
select
    id,
    customer_name,
    order_id
from ecommerce_sales
where id is null
   or id < 0
order by id;


--- Memeriksa variasi penulisan kategori
select
    lower(trim(category)) as nilai_normalisasi,
    count(distinct category) as variasi_penulisan,
    string_agg(distinct category, ' | ') as contoh_penulisan
from ecommerce_sales
where category is not null
  and trim(category) <> ''
group by lower(trim(category))
having count(distinct category) > 1
order by nilai_normalisasi;


--- Memeriksa variasi penulisan nama produk
select
    lower(trim(product)) as nilai_normalisasi,
    count(distinct product) as variasi_penulisan,
    string_agg(distinct product, ' | ') as contoh_penulisan
from ecommerce_sales
where product is not null
  and trim(product) <> ''
group by lower(trim(product))
having count(distinct product) > 1
order by nilai_normalisasi;


--- Memeriksa variasi penulisan metode pembayaran
select
    lower(trim(payment_method)) as nilai_normalisasi,
    count(distinct payment_method) as variasi_penulisan,
    string_agg(distinct payment_method, ' | ') as contoh_penulisan
from ecommerce_sales
where payment_method is not null
  and trim(payment_method) <> ''
group by lower(trim(payment_method))
having count(distinct payment_method) > 1
order by nilai_normalisasi;


--- Memeriksa variasi penulisan status
select
    lower(trim(status)) as nilai_normalisasi,
    count(distinct status) as variasi_penulisan,
    string_agg(distinct status, ' | ') as contoh_penulisan
from ecommerce_sales
where status is not null
  and trim(status) <> ''
group by lower(trim(status))
having count(distinct status) > 1
order by nilai_normalisasi;


--- Memeriksa format quantity yang tidak sesuai pola angka
select
    id,
    quantity
from ecommerce_sales
where quantity is not null
  and trim(quantity) <> ''
  and lower(trim(quantity)) not in ('n/a', 'unknown', 'nan')
  and trim(quantity) !~ '^-?[0-9]+(\.[0-9]+)?$'
order by id;


--- Memeriksa format price yang perlu ditinjau
select
    id,
    price
from ecommerce_sales
where price is not null
  and trim(price) <> ''
  and lower(trim(price)) not in ('n/a', 'unknown', 'nan')
  and trim(price) !~ '^-?[0-9]+(\.[0-9]+)?$'
order by id;


--- Memeriksa nilai negatif dan nol
select
    count(*) filter (
        where total < 0
    ) as total_negatif,
    count(*) filter (
        where total = 0
    ) as total_nol,
    count(*) filter (
        where total is null
    ) as total_null
from ecommerce_sales;


--- Memeriksa rentang nilai total
select
    min(total) as total_minimum,
    max(total) as total_maksimum,
    avg(total) as total_rata_rata
from ecommerce_sales;


--- Memeriksa rentang quantity dan price yang dapat dikonversi
with data_numerik as (
    select
        case
            when trim(quantity) ~ '^-?[0-9]+(\.[0-9]+)?$'
            then trim(quantity)::numeric
        end as quantity_num,
        case
            when trim(price) ~ '^-?[0-9]+(\.[0-9]+)?$'
            then trim(price)::numeric
        end as price_num
    from ecommerce_sales
)
select
    min(quantity_num) as quantity_minimum,
    max(quantity_num) as quantity_maksimum,
    min(price_num) as price_minimum,
    max(price_num) as price_maksimum
from data_numerik;


-- =========================
-- KONSISTENSI ANTARKOLOM
-- =========================

--- Memeriksa kesesuaian quantity, price, dan total
with data_numerik as (
    select
        id,
        quantity,
        price,
        total,
        case
            when trim(quantity) ~ '^-?[0-9]+(\.[0-9]+)?$'
            then trim(quantity)::numeric
        end as quantity_num,
        case
            when trim(price) ~ '^-?[0-9]+(\.[0-9]+)?$'
            then trim(price)::numeric
        end as price_num
    from ecommerce_sales
)
select
    id,
    quantity,
    price,
    total,
    quantity_num * price_num as total_hasil_hitung
from data_numerik
where quantity_num is not null
  and price_num is not null
  and total is not null
  and round(quantity_num * price_num, 2) <> round(total::numeric, 2)
order by id;


-- =========================
-- PEMERIKSAAN FORMAT TANGGAL
-- =========================

--- Menemukan tanggal yang tidak sesuai pola YYYY-MM-DD
select
    id,
    order_date
from ecommerce_sales
where order_date is not null
  and trim(order_date) <> ''
  and lower(trim(order_date)) not in ('n/a', 'unknown', 'nan')
  and trim(order_date) !~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
order by id;


--- Memeriksa nilai tanggal kosong dan placeholder
select
    id,
    order_date
from ecommerce_sales
where order_date is null
   or trim(order_date) = ''
   or lower(trim(order_date)) in ('n/a', 'unknown', 'nan')
order by id;


--- Melihat distribusi tanggal
select
    order_date,
    count(*) as banyak_data
from ecommerce_sales
group by order_date
order by order_date;

