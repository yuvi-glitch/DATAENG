-- Number Of Bathrooms And Bedrooms
select 
city,
property_type,
avg(bathrooms),
avg(bedrooms) 
from airbnb_search_details group by city , property_type;

-- Reviews of Hotel Arena
select
hotel_name ,
reviewer_score,count(*)
from hotel_reviews
where hotel_name = 'Hotel Arena'
group by 1,2;

-- consumed theory content for cta's and temp tables from data with bara sql tutorial in youtube
/* CTA  vs TEMP tables
| Feature     | CTAS (CREATE TABLE AS) | Temporary Table          |
| ----------- | ---------------------- | ------------------------ |
| Lifetime    | Permanent              | Session-based            |
| Storage     | Stored permanently     | Temporary storage        |
| Visibility  | All users              | Only your session        |
| Use case    | Final datasets         | Intermediate logic       |
| Performance | Fast (bulk load)       | Fast (small/medium data) |*/
