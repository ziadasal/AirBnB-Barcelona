-- Q.1: Cheapest and most available listing in January 2024
SELECT TOP 1 c.listing_id,l.name, MIN(c.price) AS cheapest_price, COUNT(*) AS availability
FROM calendar_Fact c
JOIN date_Dim d
ON c.date_key = d.date_key
JOIN listing_Dim l
ON c.listing_id = l.listing_id
WHERE month = 1 AND year = 2024
GROUP BY c.listing_id ,l.name
ORDER BY cheapest_price, availability DESC;

--Q.2: Most reviewed listings in November 2023
SELECT TOP 5 r.listing_id,l.name,COUNT(*) AS total_reviews
FROM review_Fact r
JOIN date_Dim d
ON r.date_key = d.date_key
JOIN listing_Dim l
ON r.listing_id = l.listing_id 
WHERE month = 11 AND year = 2023
GROUP BY r.listing_id,l.name
ORDER BY total_reviews DESC;

--Q.3: Most expensive neighborhood in Barcelona
SELECT l.neighbourhood_group_cleansed, AVG(l.price) AS average_price
FROM listing_Dim l
JOIN calendar_Fact c 
ON l.listing_id = c.listing_id
GROUP BY neighbourhood_group_cleansed
ORDER BY average_price DESC;

-- Q.4: Recommendations for vacationers
-- For a man with his wife and 2 children looking for a week vacation around March 2024:
WITH AvailableDays AS (
    SELECT
        c.listing_id,
        d.date,
        ROW_NUMBER() OVER (PARTITION BY c.listing_id ORDER BY d.date) AS rn
    FROM
        calendar_Fact c
    JOIN
        date_Dim d ON c.date_key = d.date_key
    WHERE
        d.year = 2024
        AND d.month = 3
        AND c.available = 1  -- Assuming 't' represents availability
),
ConsecutiveDays AS (
    SELECT
        listing_id,
        MIN(date) AS start_date,
        MAX(date) AS end_date,
        COUNT(*) AS available_days
    FROM
        AvailableDays
    GROUP BY
        listing_id,
        DATEADD(day, -rn, date)
)
SELECT TOP 3
    c.listing_id,
	name,
	accommodates,
    available_days,
	price
FROM
    ConsecutiveDays c
JOIN 
	listing_Dim l
ON l.listing_id = c.listing_id
WHERE
    available_days >= 7  AND accommodates >=4 AND name LIKE '%2 bedrooms%4 beds%'
ORDER BY
    price,available_days DESC, start_date ASC;

-- A colleage student with 4 other students who don't have alot of money and
-- want to spend the new year's eve in Barcelona with perhaps two days before and/or two days after
SELECT Distinct TOP 5 l.listing_id , l.name ,l.accommodates, l.price
FROM listing_Dim l
JOIN calendar_Fact c
ON l.listing_id = c.listing_id
JOIN date_Dim d
ON d.date_key = c.date_key
WHERE d.date  BETWEEN '2023-12-30' AND '2024-01-01' AND accommodates >=5 
		AND l.price IS NOT NULL AND available=1 AND minimum_nights>=3 
		AND name LIKE '%5 beds%'
ORDER BY l.price ASC
