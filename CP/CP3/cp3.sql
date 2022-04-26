-- ?????? ??????? ???????? ?? ?????
-- ????????? ?????? ?? 11:50

SELECT * FROM data;

-- ???????? ?? ?????????? ???? h1
-- ????????? ?????? ????

SELECT
    CASE
        WHEN REGEXP_LIKE(VALUE,'<p>')
        THEN REPLACE(REPLACE( REGEXP_SUBSTR(VALUE, '<p>(.*?)<'), '<p>', ''), '<', '')
    END AS id,
    CASE
        WHEN REGEXP_LIKE(VALUE,'<h1>')
        THEN REPLACE(REPLACE( REGEXP_SUBSTR(VALUE, '<h1>(.*?)<'), '<h1>', ''), '<', '')
    END AS category,
        CASE
        WHEN REGEXP_LIKE(VALUE,'<p class="title">')
        THEN REPLACE(REPLACE( REGEXP_SUBSTR(VALUE, '<p class="title">(.*?)<'), '<p class="title">', ''), '<', '')
    END AS title,
    CASE
        WHEN REGEXP_LIKE(VALUE,'<p class="author">')
        THEN REPLACE(REPLACE( REGEXP_SUBSTR(VALUE, '<p class="author">(.*?)<'), '<p class="author">', ''), '<', '')
    END AS author,
    CASE
        WHEN REGEXP_LIKE(VALUE,'<p class="price">')
        THEN REPLACE(REPLACE( REGEXP_SUBSTR(VALUE, '<p class="price">(.*?)<'), '<p class="price">', ''), '<', '')
    END AS price
FROM data;

-- ??? ??

