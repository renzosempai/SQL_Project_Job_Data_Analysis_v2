-- January
CREATE TABLE january_jobs AS
    SELECT
        *
    FROM job_postings_fact
    WHERE
        EXTRACT(MONTH from job_posted_date) = 1;

-- February
CREATE TABLE february_jobs AS
    SELECT
        *
    FROM job_postings_fact
    WHERE
        EXTRACT(MONTH from job_posted_date) = 2;

-- March
CREATE TABLE march_jobs AS
    SELECT
        *
    FROM job_postings_fact
    WHERE
        EXTRACT(MONTH from job_posted_date) = 3;

SELECT
    count(job_id) as number_of_jobs,
--    job_title_short,
--    job_location,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM 
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY 
    location_category
LIMIT 1000
;

-- Practice Problem #1


SELECT *
from job_postings_fact
;