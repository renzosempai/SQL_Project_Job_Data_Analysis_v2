-- Query 3. Most In-demand skills for Data Analyst
/*
Question: What are the most in-demand skills for data analysts? - Join job postings to inner join table similar to query 2
- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market, providing insights into the most valuable skills for job seekers.
*/

-- my version

WITH skill_retrieval AS(
    SELECT skjd.job_id, skjd.skill_id, skd.skills
    FROM skills_job_dim AS skjd
    INNER JOIN skills_dim AS skd
        ON skjd.skill_id = skd.skill_id
)

SELECT
    skr.skills, 
    COUNT(jpf.job_id) as job_postings
FROM job_postings_fact AS jpf
INNER JOIN skill_retrieval AS skr
    on jpf.job_id = skr.job_id
WHERE 
    jpf.job_title_short = 'Data Analyst' 
    AND skr.skill_id IS NOT NULL
GROUP BY 
    skills
ORDER BY 
    job_postings DESC
LIMIT 5
;

-- luke b's version

SELECT
    skills,
    COUNT(skills_job_dim.job_id) as demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id 
WHERE
    job_title_short = 'Data Analyst'
    AND 
    skills_dim.skill_id IS NOT NULL
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
;