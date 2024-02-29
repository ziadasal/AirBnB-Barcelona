# Source Data
**Dataset Name**: Airbnb Listings, Reviews, and Calendar Data For Barcelona, Spain

**Description**:
The dataset contains information about Airbnb listings, including details about the properties, host information, availability, reviews, and calendar information. This dataset can be used for various analyses, such as understanding pricing trends, property popularity, host behavior, and more.

**Tables**:

1. **Listings Table**:
   - Contains detailed information about Airbnb listings.
   - Attributes include:
     - `id`: Unique identifier for each listing.
     - `listing_url`: URL of the listing.
     - `scrape_id`: Identifier for the scraping operation.
     - `last_scraped`: Date when the listing was last scraped.
     - `source`: Source of the listing data.
     - `name`: Name of the listing.
     - `description`: Description of the listing.
     - `neighborhood_overview`: Overview of the neighborhood.
     - `picture_url`: URL of the listing's picture.
     - Host-related attributes (`host_id`, `host_name`, `host_since`, etc.).
     - Location-related attributes (`neighbourhood`, `neighbourhood_cleansed`, `latitude`, `longitude`, etc.).
     - Property-related attributes (`property_type`, `room_type`, `accommodates`, `bathrooms`, `bedrooms`, `beds`, `amenities`, `price`, etc.).
     - Availability-related attributes (`has_availability`, `availability_30`, `availability_60`, `availability_90`, `availability_365`, etc.).
     - Review-related attributes (`number_of_reviews`, `review_scores_rating`, `review_scores_accuracy`, etc.).
     - Other miscellaneous attributes.

2. **Reviews Table**:
   - Contains information about reviews for Airbnb listings.
   - Attributes include:
     - `listing_id`: Foreign key referencing the listing ID.
     - `id`: Unique identifier for each review.
     - `date`: Date of the review.
     - `reviewer_id`: Unique identifier for the reviewer.
     - `reviewer_name`: Name of the reviewer.
     - `comments`: Review comments provided by the reviewer.

3. **Calendar Table**:
   - Contains availability and pricing information for Airbnb listings.
   - Attributes include:
     - `listing_id`: Foreign key referencing the listing ID.
     - `date`: Date of the availability.
     - `available`: Indicator of availability.
     - `price`: Price for the listing on that date.
     - `adjusted_price`: Adjusted price for the listing on that date.
     - `minimum_nights`: Minimum nights required for booking.
     - `maximum_nights`: Maximum nights allowed for booking.
