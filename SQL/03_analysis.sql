-- KPI Analysis and Exploration

-- Checking average rating overall
SELECT AVG(rating)
FROM product_reviews_clean;
-- Average rating should be around 4.75 / 5; shows general satisfaction with wireless speakers overall

-- Getting the most commonly reviewed of our selected products 
SELECT product_name, COUNT(*)
FROM product_reviews_clean
GROUP BY product_name
ORDER BY COUNT(*) DESC;
-- With the exception of the Beats Pill (55 reviews), all wireless speakers have 100-120 reviews

-- Getting the % and count of verified reviews for each speaker
SELECT product_name, COUNT(*) AS total_reviews,
COUNT(CASE WHEN is_verified = 1 THEN 1 END) AS verified_reviews, 
COUNT(CASE WHEN is_verified = 1 THEN 1 END) * 1 / COUNT(*) AS verified_rev_pct
FROM product_reviews_clean
GROUP BY product_name;
-- The ULT field and Beats Pill have no verified reviews 
-- All th other speakers have only verified reviews

-- Getting the average rating for each product
SELECT product_name, COUNT(*) AS total_reviews, AVG(rating) AS avg_rating
FROM product_reviews_clean
GROUP BY product_name;
-- All are between 4-5 stars on average, with the Charge 5 being slightly higher than the others

-- Getting the average helpful_count (is review helpful) for each product
SELECT product_name, SUM(helpful_count) AS helpful_count, COUNT(*) AS total_reviews, AVG(helpful_count)
FROM product_reviews_clean
GROUP BY product_name
ORDER BY AVG(helpful_count);
-- Three products (Beats, Sony and Marshall) have 0 helpful counts which could indicate some sampling issues with the dataset

-- Calculating the earliest and latest dates as well as the time span for each reviewable product
SELECT product_name, MIN(review_date_clean) as earliest_date, 
MAX(review_date_clean) AS latest_date,
MAX(review_date_clean) - MIN(review_date_clean) AS review_span_days
FROM product_reviews_clean
GROUP BY product_name
-- The Marshall has the longest time span for reviews

-- Checking the review length for each review
SELECT product_name, reviews, LENGTH(reviews)
FROM product_reviews_clean

-- Performing time-based analysis for each product 

-- Checking total reviews, average reviews, and average helpful count per month by product
SELECT product_name,
DATE_TRUNC('month', review_date_clean) AS date_month,
COUNT(*) AS total_reviews,
COUNT(helpful_count) AS total_helpful_count,
ROUND(AVG(rating), 2) AS average_rating,
ROUND(AVG(helpful_count), 2) AS average_helpful_count
FROM product_reviews_clean
GROUP BY product_name, date_month
ORDER BY product_name, date_month
-- The earliest tracked reviews only had one or 2 per month in fact the Marshall was the only speaker with reviews in 2022 and 2023
-- 2024 - 2025 is where the bulk of the review are for each product
-- The helpful reviews started to increase in 2024 trough 2025
-- Average rating remains consistently high through most months with ratings rarely dipping below 4

-- Polarity analysis

-- Getting average polarity and subjectivity per review by product
SELECT product_name, AVG(review_subjectivity) AS subjectivity, AVG(review_polarity) AS polarity
FROM product_reviews_clean
GROUP BY product_name;
-- THe Charge 5 has the most positive reviews with the highest polarity score 

-- Checking the average polarity by star rating (1-5)
SELECT rating, AVG(review_polarity) AS polarity
FROM product_reviews_clean
GROUP BY rating;
-- The polarity trends follow the expected pattern with 1 star reviews being the lowest polarity and 5 stars being the highestp polarity

-- Getting the average review polarity/subjectivity for each product for every month they have been reviewed
SELECT product_name, 
DATE_TRUNC('month', review_date_clean) AS date_month,
COUNT(*) AS total_reviews,
AVG(rating) AS avg_rating,
AVG(review_polarity) AS avg_polarity,
AVG(review_subjectivity) AS avg_subjectivity 
FROM product_reviews_clean
GROUP BY product_name, date_month
ORDER BY product_name, date_month;
-- Average rating stays relatively consistent but polarity and subjectivity vary from month to month.

-- Adding negative, neutral and positive sentiment 
SELECT product_name, 
CASE
WHEN review_polarity < -0.1 THEN 'negative'
WHEN review_polarity BETWEEN -0.1 AND 0.1 THEN 'neutral'
WHEN review_polarity > 0.1 THEN 'positive'
END AS sentiment_label,
COUNT(*) AS review_count
FROM product_reviews_clean
GROUP BY product_name, sentiment_label
ORDER BY product_name, sentiment_label;
-- This confirms that the majority of reviews are positive with the majority of reviews for each speaker being in the positive category.

-- Calculating the percentage of each review classification (positive, negative and neutral)
SELECT product_name, 
CASE
WHEN review_polarity < -0.1 THEN 'negative'
WHEN review_polarity BETWEEN -0.1 AND 0.1 THEN 'neutral'
WHEN review_polarity > 0.1 THEN 'positive'
END AS sentiment_label,
COUNT(*) AS review_count,
SUM(COUNT(*)) OVER (PARTITION BY product_name) AS total_product_reviews,
ROUND((COUNT(*) * 100) / SUM(COUNT(*)) OVER (PARTITION BY product_name), 2) AS sentiment_pct
FROM product_reviews_clean
GROUP BY product_name, sentiment_label
ORDER BY product_name, sentiment_label;