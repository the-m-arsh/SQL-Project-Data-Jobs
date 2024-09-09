/*
What are the top_paying data analyst jobs?
- Top 10 highest_paying Data Analyst roles that are available remotely.
- Job postings w/ specified salaries (remove nulls)
** Highlighted opportunities for Data Analysts, 
    offering insights into employment 
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
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