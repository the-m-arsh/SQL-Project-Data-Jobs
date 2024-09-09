/*
What are the top paying skills based on Salary?
- Avg. salary associated w/ each skill for Data Analyst positions
- Focuses on roles w/ specified salaries, regardless of location
** Reveals how different skills impact salary levels for Data Analysts & helps
    identify the most financially rewarding skills to acquire or improve
*/

SELECT
    skills,
    ROUND (AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25

/*
Key Trends:

- Cross-Disciplinary Skills Are Valuable: The skills in highest demand combine expertise in data analysis with knowledge of emerging technologies (blockchain, cloud computing) and collaboration tools.
- Cloud and Automation: There is a significant shift toward cloud-based infrastructure and automation tools, making skills in tools like Terraform, Ansible, and VMware highly valuable.
- Real-Time Data Processing: Proficiency in Kafka, Couchbase, and Cassandra reflects the growing need for real-time and large-scale data processing systems.
- Machine Learning Specialization: Data analysts are increasingly expected to have knowledge of machine learning and AI frameworks, as predictive and prescriptive analytics become more critical.

In conclusion, the top-paying data analyst jobs tend to require specialized technical skills in cloud infrastructure, machine learning, and decentralized technologies like blockchain. 
The convergence of these skills with data analysis leads to higher salaries and greater demand.
*/