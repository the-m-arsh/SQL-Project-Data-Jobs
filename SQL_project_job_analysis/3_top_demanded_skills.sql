/*
What are the most in-demand skills for data analysts?
- Similar query to query 2
- Identify Top 5 in-demand skills for a data analyst.
- Focus on all job postings.
** Retrieves the top 5 skills w/ the highest demand in the the job market, providing
    insights into the most valuable skills for job seekers.
*/

SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5