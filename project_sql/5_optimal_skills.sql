-- Query 5. Most Optimal Skills
/*
Question: What are the most optimal skills to learn (aka it's in high demand and a high-paying skill)? 
- Identify skills in high demand and associated with high average salaries for Data Analyst roles 
- Concentrates on remote positions with specified salaries
Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis
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
    COUNT(jpf.job_id) as job_postings,
    ROUND(AVG(jpf.salary_year_avg),0) as avg_salary
FROM job_postings_fact AS jpf
INNER JOIN skill_retrieval AS skr
    on jpf.job_id = skr.job_id
WHERE
    jpf.job_title_short = 'Data Analyst'
    AND
    salary_year_avg IS NOT NULL
    AND
    job_work_from_home = TRUE
GROUP BY 
    skill_id, 
    skills
HAVING
    COUNT(jpf.job_id) > 10
ORDER BY 
    avg_salary DESC,
    job_postings DESC
LIMIT 1000
;

-- luke b's version

WITH skills_demand AS (
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN 
    skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id 
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL 
    AND job_work_from_home = True
GROUP BY
    skills_dim.skill_id
)
, average_salary AS (
SELECT
    skills_job_dim.skill_id,
    ROUND (AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary 
FROM job_postings_fact
INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id 
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM skills_demand
INNER JOIN average_salary 
    ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
;