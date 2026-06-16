-- NOTE: All of these queries can be run in PostGreSQL
-- Inspecting Data and Checking Missing/Duplicate values

-- Inspecting Data
SELECT * FROM reviews
LIMIT 10;

-- Checking Missing Values
SELECT COUNT(*) AS total_rows,
COUNT(content) AS review_text_count,
COUNT(rating) AS rating_count
FROM reviews;

-- Checking Duplicate Values
-- Returns all duplicates in the amazon dataset
SELECT COUNT(*), reviews, product_id, rating, reviews.timestamp
FROM reviews
GROUP BY reviews, product_id, rating, reviews.timestamp
HAVING COUNT(*) > 1;

-- Getting the most commonly reviewed products
SELECT product_id, COUNT(*)
FROM reviews
GROUP BY product_id
ORDER BY COUNT(*) DESC;