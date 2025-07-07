
-- #2
SELECT
    job_posted_date,
    EXTRACT(month from job_posted_date AT TIME ZONE 'UTC') as month,
    count(job_id) as job_posting_count
FROM 
    job_postings_fact
WHERE 
    EXTRACT(YEAR from job_posted_date) = '2023'
GROUP BY 
    job_posted_date
ORDER BY 
    2 desc
LIMIT 1000
;

-- #3
SELECT 
    job_postings.company_id as company_id,
    companies.name as company,
--    job_postings.job_health_insurance as has_health_insurance,
    job_posted_date,
    EXTRACT(QUARTER FROM job_posted_date) as quarter_month
FROM 
    job_postings_fact as job_postings
LEFT JOIN company_dim as companies
    ON job_postings.company_id = companies.company_id
WHERE 
    job_postings.job_health_insurance = TRUE
    AND
    EXTRACT(QUARTER FROM job_posted_date) = 2
;

SELECT *
from job_postings_fact
LIMIT 1000
;