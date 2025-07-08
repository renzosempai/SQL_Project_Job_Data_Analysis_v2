-- Query 4. Top Paying Skills
/*
Question: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analysts and helps identify the most financially rewarding skills to acquire or improve
*/

-- my version

WITH skill_retrieval AS(
    SELECT skjd.job_id, skjd.skill_id, skd.skills
    FROM skills_job_dim AS skjd
    INNER JOIN skills_dim AS skd
        ON skjd.skill_id = skd.skill_id
)

SELECT 
    skr.skill_id, 
    skr.skills,
    ROUND(AVG(jpf.salary_year_avg),0) as avg_salary
FROM job_postings_fact AS jpf
INNER JOIN skill_retrieval AS skr
    on jpf.job_id = skr.job_id
WHERE
    jpf.job_title_short = 'Data Analyst'
    AND
    salary_year_avg IS NOT NULL
GROUP BY skill_id, skills
ORDER BY 3 DESC
LIMIT 100
;

-- luke b's version

SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) as avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id 
WHERE
    job_title_short = 'Data Analyst'
    AND
    salary_year_avg IS NOT NULL
    -- AND
    -- job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25
;

