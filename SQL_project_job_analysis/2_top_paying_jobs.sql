/*
what skills are required for the top_paying data analyst jobs?
- Use the first query
- Add specific skills required for these roles
** Provides a detailed look at which high-paying jobs demand certain skills, 
    helping job seekers understand which skills to develop that align w/ top salaries
*/

WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC

/*
Here's the breakdown of the most demanded skills for data analysts in 2023, 
based on job postings:
- SQL is a leading skill for Data Analysts
- Python follows closely
- Tableau is also highly sought after
- Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand 
*/ 