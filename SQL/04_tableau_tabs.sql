-- Using SQL to create tables for easier analyis in tableau 

-- Creating a product_summary table for easier analysis in sql 
CREATE TABLE product_summary 
AS SELECT product_name, 
COUNT(*) AS total_reviews,
COUNT(CASE WHEN is_verified = 1 THEN 1 END) AS verified_reviews,
COUNT(CASE WHEN is_verified = 1 THEN 1 END) * 1.0 / COUNT(*) AS verified_rev_pct,
AVG(rating) AS avg_rating,
SUM(helpful_count) AS total_helpful_count,
AVG(helpful_count) AS avg_helpful_count,
MAX(review_date_clean) AS latest_date,
MIN(review_date_clean) AS earliest_date,
MAX(review_date_clean) - MIN(review_date_clean) AS review_span_days
FROM product_reviews_clean
GROUP BY product_name

--Adding average review lengths to the summary table 
ALTER TABLE product_summary 
ADD avg_review_length bigint;

UPDATE product_summary
SET avg_review_length = avg_lengths.avg_review_length
FROM (
SELECT 
product_name,
AVG(review_length) AS avg_review_length
FROM product_reviews_clean
GROUP BY product_name
) avg_lengths
WHERE product_summary.product_name = avg_lengths.product_name;

--Creating a monthly review trends table 
CREATE TABLE monthly_review_trends 
AS SELECT product_name,
DATE_TRUNC('month', review_date_clean) AS date_month,
COUNT(*) AS total_reviews,
COUNT(helpful_count) AS total_helpful_count,
ROUND(AVG(rating), 2) AS average_rating,
ROUND(AVG(helpful_count), 2) AS average_helpful_count
FROM product_reviews_clean
GROUP BY product_name, date_month
ORDER BY product_name, date_month

-- Adding average polarity, average subjectivity, positive, negative and neutral polarity percentages of reviews 
-- Adding average polartity/subjectivity
UPDATE product_summary
SET avg_polarity = avg_pol.polarity,
avg_subjectivity = avg_pol.subjectivity
FROM (
SELECT product_name,  AVG(review_subjectivity) AS subjectivity, AVG(review_polarity) AS polarity
FROM product_reviews_clean
GROUP BY product_name
) avg_pol
WHERE product_summary.product_name = avg_pol.product_name;

-- Adding polarity classification percentages
UPDATE product_summary
SET positive_rev_pct = pcts.pos_revs_pct,
negative_rev_pct = pcts.neg_revs_pct,
neutral_rev_pct = pcts.neut_revs_pct
FROM (
SELECT product_name,
ROUND(COUNT(CASE WHEN review_polarity < -0.1 THEN 1 END) * 100.0 / COUNT(*), 3) AS neg_revs_pct,
ROUND(COUNT(CASE WHEN review_polarity BETWEEN -0.1 AND 0.1 THEN 1 END) * 100.0 / COUNT(*), 3) AS neut_revs_pct,
ROUND(COUNT(CASE WHEN review_polarity > 0.1 THEN 1 END) * 100.0 / COUNT(*), 3) AS pos_revs_pct
FROM product_reviews_clean
GROUP BY product_name
) pcts
WHERE product_summary.product_name = pcts.product_name