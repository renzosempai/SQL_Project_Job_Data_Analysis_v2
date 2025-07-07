SELECT 
    job_title_short,
    company_id,
    job_location
FROM january_jobs

UNION ALL

SELECT 
    job_title_short,
    company_id,
    job_location
FROM february_jobs

UNION ALL

SELECT 
    job_title_short,
    company_id,
    job_location
FROM march_jobs
;


-- Practice Problem 1
/*

Get the corresponding skill and skill type for each job posting in q1
Includes those without any skills, too
Why? Look at the skills and the type for each job in the first quarter that has a salary > $70,000
*/

WITH cte_job_id AS(
    SELECT 
        quarter_job_postings.job_id,
        skill_id
    FROM(
        SELECT * 
        FROM january_jobs
        UNION
        SELECT * 
        FROM february_jobs
        UNION
        SELECT * 
        FROM march_jobs
    ) AS quarter_job_postings
    INNER JOIN skills_job_dim AS skjd
        ON quarter_job_postings.job_id = skjd.job_id
    WHERE 
        EXTRACT(QUARTER from job_posted_date) = 1
        and
        salary_year_avg > 70000
)

SELECT 
    cte_job_id.job_id,
    skd.skills AS skills,
    skd.type AS skill_type
FROM cte_job_id
INNER JOIN skills_dim AS skd
    ON cte_job_id.skill_id = skd.skill_id
;


-- Practice Problem 2
/*
Find job postings from the first quarter that have a salary greater than $70K 
- Combine job posting tables from the first quarter of 2023 (Jan-Mar)
- Gets job postings with an average yearly salary > $70,000
*/

SELECT * 
FROM january_jobs
WHERE 
    salary_year_avg > 70000

UNION

SELECT * 
FROM february_jobs
WHERE 
    salary_year_avg > 70000

UNION

SELECT * 
FROM march_jobs
WHERE 
    salary_year_avg > 70000


SELECT *
FROM job_postings_fact
LIMIT 1000
;

SELECT *
FROM skills_job_dim
LIMIT 1000
;

SELECT *
FROM skills_dim
LIMIT 1000
;