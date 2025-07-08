-- Query 2. Top Paying Jobs' skills
/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills, helping job seekers understand which skills to develop that align with top salaries
*/

WITH skill_finder AS(
    SELECT 
        job_id,
        skills_dim.skills AS skills
    FROM skills_dim
    INNER JOIN skills_job_dim
        on skills_dim.skill_id = skills_job_dim.skill_id
    GROUP BY job_id, skills
)

SELECT 
    job_postings.job_id,
    -- job_title_short,
    job_title,
    skill_finder.skills,
    name as company_name,
    salary_year_avg
FROM job_postings_fact AS job_postings
LEFT JOIN company_dim
    ON job_postings.company_id = company_dim.company_id
INNER JOIN skill_finder
    on job_postings.job_id = skill_finder.job_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 100
;


-- SELECT
--     job_id,
--     job_title_short,
--     job_title,
--     name as company_name,
--     salary_year_avg
-- FROM job_finder
-- INNER JOIN skill_finder
--     ON job_finder.job_id = skill_finder.job_id
-- LIMIT 1000
-- ;

SELECT *
FROM job_postings_fact
LIMIT 1000
;