-- Preprocessing Data
-- Renaming column 'content' to 'reviews' for ease of use and understanding
ALTER TABLE reviews 
RENAME COLUMN 'content' TO 'reviews';

-- Creating a products table for top 5 products
-- First selecting the products for analysis and getting the counts(1 products by Beats by Dre and 4 competitor products) 
SELECT product_id, COUNT(*)
FROM reviews 
WHERE product_id IN ('B08X4YMTPM', 'B09XXW54QG', 'B0CXL4FQBK', 'B099TLMRB6', 'B0D4STD5ZC')
GROUP BY product_id
ORDER BY COUNT(*) DESC;

-- Creating a products table for selected products 
CREATE TABLE selected_products
AS SELECT DISTINCT(product_id) FROM reviews
WHERE product_id IN ('B08X4YMTPM', 'B09XXW54QG', 'B0CXL4FQBK', 'B099TLMRB6', 'B0D4STD5ZC');

-- Added a product name column
ALTER TABLE selected_products
ADD product_name VARCHAR(20);

-- Mapped the specific selected products to the correct product_id
UPDATE selected_products
SET product_name = 
CASE 
WHEN product_id = 'B08X4YMTPM' THEN 'JBL Charge 5'
WHEN product_id = 'B09XXW54QG' THEN 'Marshall Emberton II'
WHEN product_id = 'B0CXL4FQBK' THEN 'Sony ULT Field'
WHEN product_id = 'B099TLMRB6' THEN 'Bose Soundlink Flex'
WHEN product_id = 'B0D4STD5ZC' THEN 'Beats Pill'
ELSE 'Unknown Product'
END;

-- Creating a final reviews table for analysis
CREATE TABLE product_reviews
AS SELECT reviews.review_id,
reviews.product_id,
reviews.title,
reviews.reviews,
reviews.rating, 
reviews.timestamp,
reviews.is_verified,
reviews.helpful_count,
selected_products.product_name
FROM reviews 
INNER JOIN selected_products ON reviews.product_id = selected_products.product_id;

-- Checking missing and duplicate values for the new table
SELECT COUNT(*) AS total_rows,
COUNT(review_id) AS review_id_count,
COUNT(reviews) AS review_text_count,
COUNT(rating) AS rating_count
FROM product_reviews; 

-- Checking duplicates in the new dataset
SELECT COUNT(*), reviews, product_id, rating, product_reviews.timestamp
FROM product_reviews
GROUP BY reviews, product_id, rating, product_reviews.timestamp
HAVING COUNT(*) > 1;

-- Creating a cleaned dataset that is duplicate free for analysis
CREATE TABLE product_reviews_clean
AS SELECT * 
FROM (
SELECT reviews, product_id, rating, product_reviews.timestamp,
REPLACE(product_reviews.timestamp, 'Reviewed in the United States', '') AS review_date,
ROW_NUMBER() OVER (
PARTITION BY reviews, product_id, rating, product_reviews.timestamp
ORDER BY review_id) AS row_num 

FROM product_reviews
)
WHERE row_num = 1

-- Changing column name and converting to datetime
ALTER TABLE product_reviews_clean
RENAME COLUMN "review_date" TO "review_date_clean";

ALTER TABLE product_reviews_clean
ALTER COLUMN review_date_clean TYPE DATE
USING TO_DATE(review_date_clean, 'Month DD, YYYY');

-- Adding review polarity and subjectivity from our python analysis
ALTER TABLE product_reviews_clean
ADD  review_subjectivity double precision

ALTER TABLE product_reviews_clean
ADD  review_polarity double precision

UPDATE product_reviews_clean
SET review_subjectivity = reviews_w_polarity.review_subjectivity
FROM reviews_w_polarity
WHERE product_reviews_clean.reviews = reviews_w_polarity.review

UPDATE product_reviews_clean
SET review_polarity = reviews_w_polarity.review_polarity
FROM reviews_w_polarity
WHERE product_reviews_clean.reviews = reviews_w_polarity.review