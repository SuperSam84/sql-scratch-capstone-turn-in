SELECT * 
FROM survey
LIMIT 10;

-- how many users move from Question 1 to Question 2, etc
SELECT question, COUNT(DISTINCT user_id) AS 'Total Responses'
FROM survey
GROUP BY 1
ORDER BY 2 DESC;

SELECT * 
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;
/*
 * Warby Parker's purchase funnel is:

 * Take the Style Quiz  Home Try-On  Purchase the
 * Perfect Pair of Glasses

 * During the Home Try-On stage, we will be conducting an 
 * A/B Test:

 * 50% of the users will get 3 pairs to try on
 * 50% of the users will get 5 pairs to try on
 * Let's find out whether or not users who get more pairs 
 * to try on at home will be more likely to make a 
 * purchase.

 * The data will be distributed across three tables:

 * quiz
 * home_try_on
 * purchase
 */

WITH funnels AS (
SELECT DISTINCT q.user_id,
				h.user_id IS NOT NULL AS 'is_home_try_on',
        h.number_of_pairs AS 'number_of_pairs',
        p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS q
LEFT JOIN home_try_on AS h
ON h.user_id = q.user_id
LEFT JOIN purchase AS p
ON p.user_id = h.user_id
--LIMIT 10
)
SELECT COUNT(*) AS 'Targeted Customers',
			number_of_pairs,
			SUM(is_home_try_on) AS 'Home Try-On',
      SUM(is_purchase) AS 'Checkout',
      -- 1.0 * SUM(is_home_try_on) / COUNT(*),
      ROUND((1.0 * SUM(is_purchase) / SUM(is_home_try_on)), 2) AS 'Conversion Rate'
FROM funnels
WHERE number_of_pairs IS NOT NULL
GROUP BY 2;

-- The most common results of the style quiz.
SELECT COUNT(*), style
FROM quiz
GROUP BY 2
ORDER BY 2 DESC;

--The most common types of purchase made.
SELECT product_id, model_name, style, price, COUNT(*)
FROM purchase
GROUP BY 1
ORDER BY 5 DESC;