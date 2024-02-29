## Airbnb Business Questions README

This README provides answers to specific business questions based on the Airbnb Data Warehouse (DWH) after the ETL process and modeling. Each question is answered using SQL queries against the DWH tables.

### Q.1: Cheapest and Most Available Listing in January 2024
```sql
SELECT TOP 1 c.listing_id,l.name, MIN(c.price) AS cheapest_price, COUNT(*) AS availability
FROM calendar_Fact c
JOIN date_Dim d
ON c.date_key = d.date_key
JOIN listing_Dim l
ON c.listing_id = l.listing_id
WHERE month = 1 AND year = 2024
GROUP BY c.listing_id ,l.name
ORDER BY cheapest_price, availability DESC;
```

The cheapest and most available listing in January 2024 is as follows:

- **Listing ID**: 49999878
- **Listing Name**: Condo in Barcelona · 1 bedroom · 2 beds · 1 shared bath
- **Cheapest Price**: $9
- **Availability**: 31 days

### Q.2: Most Reviewed Listings in November 2023

```sql
SELECT TOP 5 r.listing_id,l.name,COUNT(*) AS total_reviews
FROM review_Fact r
JOIN date_Dim d
ON r.date_key = d.date_key
JOIN listing_Dim l
ON r.listing_id = l.listing_id 
WHERE month = 11 AND year = 2023
GROUP BY r.listing_id,l.name
ORDER BY total_reviews DESC;
```

The top 5 most reviewed listings in November 2023 are as follows:

1. **Hostel in Barcelona**: 52981104 - Total Reviews: 163
2. **Serviced Apartment in Barcelona**: 846093318788581404 - Total Reviews: 70
3. **Boutique Hotel in Barcelona**: 24424717 - Total Reviews: 63
4. **Serviced Apartment in Eixample**: 26940439 - Total Reviews: 50
5. **Serviced Apartment in Barcelona**: 30759793 - Total Reviews: 46

### Q.3: Most Expensive Neighborhood in Barcelona
```sql
SELECT l.neighbourhood_group_cleansed, AVG(l.price) AS average_price
FROM listing_Dim l
JOIN calendar_Fact c 
ON l.listing_id = c.listing_id
GROUP BY neighbourhood_group_cleansed
ORDER BY average_price DESC;
```
The most expensive neighborhood in Barcelona, based on average listing price, is Horta-Guinardó with an average price of $219.99.

### Q.4: Recommendations for Vacationers

#### For a Man with His Wife and 2 Children Looking for a Week Vacation around March 2024:
```sql
WITH AvailableDays AS (
    SELECT
        c.listing_id,
        d.date,
        ROW_NUMBER() OVER (PARTITION BY c.listing_id ORDER BY d.date) AS rn
    FROM calendar_Fact c
    JOIN date_Dim d ON c.date_key = d.date_key
    WHERE d.year = 2024 AND d.month = 3 AND c.available = 1 
),
ConsecutiveDays AS (
    SELECT
        listing_id,
        MIN(date) AS start_date,
        MAX(date) AS end_date,
        COUNT(*) AS available_days
    FROM AvailableDays
    GROUP BY listing_id, DATEADD(day, -rn, date)
)
SELECT TOP 3 c.listing_id, name, accommodates, available_days, price
FROM ConsecutiveDays c
JOIN listing_Dim l
ON l.listing_id = c.listing_id
WHERE available_days >= 7 AND accommodates >=4 AND name LIKE '%2 bedrooms%4 beds%'
ORDER BY price,available_days DESC, start_date ASC;
```
We recommend the following listings:

1. **Rental Unit in Barcelona**: Listing ID 46524035 - 2 bedrooms, 4 beds, 1 bath - Available for 31 days at a price of $24.
2. **Rental Unit in Barcelona**: Listing ID 26772799 - 2 bedrooms, 4 beds, 1.5 baths - Available for 31 days at a price of $39.
3. **Rental Unit in Barcelona**: Listing ID 944248812021534532 - 2 bedrooms, 4 beds, 1 bath - Available for 31 days at a price of $41.

#### For a College Student with 4 Other Students Planning to Spend New Year's Eve in Barcelona:
```sql
SELECT Distinct TOP 5 l.listing_id , l.name ,l.accommodates, l.price
FROM listing_Dim l
JOIN calendar_Fact c
ON l.listing_id = c.listing_id
JOIN date_Dim d
ON d.date_key = c.date_key
WHERE d.date  BETWEEN '2023-12-30' AND '2024-01-01' AND accommodates >=5 
		AND l.price IS NOT NULL AND available=1 AND minimum_nights>=3 
		AND name LIKE '%5 beds%'
ORDER BY l.price ASC;
```
We recommend the following listings:

1. **Rental Unit in Barcelona**: Listing ID 1009224004892468005 - 3 bedrooms, 5 beds, 2 shared baths - Available for the specified dates at a price of $25.
2. **Rental Unit in Barcelona**: Listing ID 18937523 - 2 bedrooms, 5 beds, 1.5 baths - Available for the specified dates at a price of $32.
3. **Home in Barcelona**: Listing ID 844309764845404095 - 1 bedroom, 5 beds, 1 shared bath - Available for the specified dates at a price of $34.
4. **Rental Unit in Barcelona**: Listing ID 32377848 - 1 bedroom, 5 beds, 1 bath - Available for the specified dates at a price of $43.
5. **Rental Unit in Barcelona**: Listing ID 704232003438197101 - 4 bedrooms, 5 beds, 2 baths - Available for the specified dates at a price of $47.

