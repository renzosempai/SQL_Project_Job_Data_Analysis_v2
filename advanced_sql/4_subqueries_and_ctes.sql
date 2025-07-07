-- Subqueries
SELECT *
FROM( -- Subquery starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH from job_posted_date) = 1
) AS january_jobs
LIMIT 1000
; -- Subquery ends here

SELECT *
FROM january_jobs
;

-- Subqueries inside Select, From, Where and Having
SELECT name as company_name
FROM company_dim
WHERE company_id in (
    SELECT company_id
    FROM job_postings_fact
    WHERE job_no_degree_mention = TRUE
)
LIMIT 1000
;

-- CTE's
WITH january_jobs2 AS( -- CTE starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH from job_posted_date) = 1
) -- CTE ends here

SELECT *
FROM january_jobs2
;

/*
Find the companies with the most job postings
- Get the total number of job postings per company id - done
- Return the total number of jobs with the company name - done
*/

WITH company_jobs AS(
    SELECT company_id, COUNT(job_id) as job_postings
    FROM job_postings_fact
    GROUP BY company_id
    LIMIT 1000
)

SELECT companies.company_id, companies.name, company_jobs.job_postings
FROM company_dim AS companies
LEFT JOIN company_jobs
    on companies.company_id = company_jobs.company_id
WHERE job_postings IS NOT NULL
ORDER BY 3 DESC
LIMIT 1000
;


-- Practice Problem 1
/*Identify the top 5 skills that are most frequently mentioned in job postings. 
Use a subquery to find the skill IDs with the highest counts in the skills_job_dim table, 
and then join this result with the skills_dim table to get the skill names.
*/

-- used CTE instead, don't know how to use Subquery for this
WITH total_skill_count AS(
    SELECT skill_id, COUNT(skill_id) as skill_count
    FROM skills_job_dim
    GROUP BY skill_id 
)

SELECT skd.skills, total_skill_count.skill_count
FROM skills_dim AS skd
LEFT JOIN total_skill_count
    ON total_skill_count.skill_id = skd.skill_id
ORDER BY skill_count DESC
LIMIT 5
;


-- Practice Problem 2
/*
Determine the size category ('Small', 'Medium', or 'Large') for each company 
by first identifying the number of job postings they have. 
Use a subquery to calculate the total job postings per company. 
A company is considered 'Small' if it has less than 10 job postings, 
'Medium' if the number of job postings is between 10 and 50, and 'Large' if it 
has more than 50 job postings. Implement a subquery to aggregate job counts 
per company before classifying them based on size.
*/

-- used CTE again, don't know how to use Subquery for this
WITH total_job_posting AS(
    SELECT company_id, COUNT(job_id) as job_postings
    FROM job_postings_fact
    GROUP BY company_id
)

SELECT 
    companies.name, 
    total_job_posting.job_postings,
    CASE
        WHEN job_postings < 10 THEN 'Small'
        WHEN job_postings between 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS company_size
FROM company_dim AS companies
LEFT JOIN total_job_posting
    ON total_job_posting.company_id = companies.company_id
ORDER BY job_postings DESC
LIMIT 1000
;


-- Practice Problem 3
/*
Find the count of the number of remote job postings per skill
- Display the top 5 skills by their demand in remote jobs
- Include skill ID, name, and count of postings requiring the skill  
*/

-- my version
WITH skill_retrieval AS(
    SELECT skjd.job_id, skjd.skill_id, skd.skills
    FROM skills_job_dim AS skjd
    LEFT JOIN skills_dim AS skd
        ON skjd.skill_id = skd.skill_id
)

SELECT skr.skill_id, skr.skills, COUNT(jpf.job_id) as job_postings
FROM job_postings_fact AS jpf
LEFT JOIN skill_retrieval AS skr
    on jpf.job_id = skr.job_id
WHERE 
    jpf.job_work_from_home = TRUE 
    AND skr.skill_id IS NOT NULL
GROUP BY skill_id, skills
ORDER BY 3 DESC
LIMIT 5
;


-- luke b's version
WITH remote_job_skills AS(
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN
        job_postings_fact AS job_postings
        ON job_postings.job_id = skills_to_job.job_id
    WHERE
        job_postings.job_work_from_home = TRUE
    GROUP BY
        skill_id
)

SELECT
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM
    remote_job_skills
INNER JOIN
    skills_dim AS skills
    ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5
;


SELECT *
FROM job_postings_fact
LIMIT 1000
;

SELECT *
FROM company_dim
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
