-- Query 1. Top Paying Jobs
/*
- Identify the top 10 highest-paying Data Analyst roles that are available remotely. 
- Focuses on job postings with specified salaries (remove nulls).
- Why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment
*/

SELECT 
    job_id,
    job_title_short,
    job_title,
    name as company_name,
    salary_year_avg
FROM job_postings_fact
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10
;

SELECT *
FROM job_postings_fact
LIMIT 1000
;