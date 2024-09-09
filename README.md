# Introduction
This project analyzes the data job market, focusing on data analyst roles. It investigates the highest-paying positions, the in-demand skills, and the areas where high demand intersects with high salaries in data analytics.

# Background
This project was undertaken to streamline the data analyst job search process by identifying the highest-paying positions and most in-demand skills. The data, sourced from [lukebarousse.com/sql](https://lukebarousse.com/sql), provides valuable insights into job titles, salaries, locations, and essential skills.

### The queries were designed to address the following questions:

1. What are the highest-earning data analyst positions?
2. What specific skills are essential for securing these lucrative roles?
3. Which data analyst skills are currently most sought after?
4. What skills correlate with higher salaries in the field?
5. What are the most advantageous skills to acquire for data analysts?"

# Tools I Utilized
To conduct a comprehensive analysis of the data analyst job market, I employed several essential tools:

- **SQL:** Served as the cornerstone of the analysis, enabling the extraction of valuable insights from the database.
- **PostgreSQL:** As the chosen database management system, PostgreSQL was well-suited to handle the extensive job posting data.
- **Visual Studio Code:** This integrated development environment facilitated efficient database management and execution of SQL queries.
- **Git & GitHub:** Instrumental in version control and collaborative project management, ensuring the effective sharing and tracking of SQL scripts and analysis.

# The Analysis
Each query within this project was designed to delve into specific aspects of the data analyst job market. The following outlines the approach taken for each question.
### 1. Top Paying Data Analyst Jobs
To identify the highest-earning data analyst positions, the data was filtered based on average annual salary and location. This analysis effectively pinpointed the most lucrative roles within the field

```sql
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
```
**Takeaway:**
The top-paying data analyst roles in 2023 exhibited a wide salary range, spanning from $184,000 to $650,000, underscoring the substantial earning potential within the field. Companies such as SmartAsset, Meta, and AT&T were among those offering these lucrative positions, demonstrating a diverse range of industries interested in data analytics expertise. Additionally, the job titles associated with these high-paying roles showcased a high degree of variety, ranging from Data Analyst to Director of Analytics, indicating the existence of diverse roles and specializations within the field of data analytics.

![](https://github.com/user-attachments/assets/d6165428-f913-442e-b78b-565a373dd9c2)
*A bar graph illustrating the salaries of the top 10 data analyst positions was generated using ChatGPT, based on the results of my SQL query*

### 2. Skills for Top Paying Jobs
To identify the skills essential for the highest-paying data analyst positions, the job postings were merged with the skills data, providing valuable insights into the qualifications valued by employers in these lucrative roles.

```sql
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
```
The most in-demand skills for data analysts in 2023, as determined by job postings, were as follows:
- **SQL:** This programming language was identified as the most sought-after skill.
- **Python:** Following closely behind, Python was also a highly valued skill.
- **Tableau:** This data visualization tool was another highly sought-after requirement.
- Other skills: **R**, **Snowflake**, **Pandas**, and **Excel** were also in varying degrees of demand.

![](https://github.com/user-attachments/assets/75568d31-ca95-417d-8d63-acf54e053dee)
*A bar graph illustrating the frequency of skills required for the top 10 highest-paying data analyst positions was generated using ChatGPT, based on my SQL query results*

### 3. In-Demand Skills for Data Analysts
This analysis effectively pinpointed the skills most commonly sought after in job postings, guiding attention towards areas of high demand.

```sql
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
```
The most in-demand skills for data analysts in 2023 were found to be:
- **SQL** and **Excel:** These foundational skills remained essential, highlighting the importance of proficiency in data processing and spreadsheet manipulation.
- **Programming & Visualization Tools**: **Python**, **Tableau**, and **Power BI** emerged as crucial skills, emphasizing the growing demand for technical expertise in data storytelling and decision support.

| Skill | Demand Count |
|---|---|
| SQL | 92628 |
| Excel | 67031 |
| Python | 57326 |
| Tableau | 46554 |
| Power BI | 39468 |

*Table of the demand for the top 5 skills in data analyst job postings*

### 4. Skills Based on Salary
An analysis of average salaries linked to various skills identified those that offered the highest earning potential.

```sql
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
```
#### Key Trends:
- **Cross-Disciplinary Skills:** The most sought-after skills combine data analysis proficiency with knowledge of emerging technologies, such as blockchain and cloud computing, along with collaboration tools.
- **Cloud and Automation:** There is a pronounced shift towards cloud-based infrastructure and automation tools, making skills in tools like Terraform, Ansible, and VMware highly valuable.
- **Real-Time Data Processing:** Proficiency in Kafka, Couchbase, and Cassandra reflects the increasing need for real-time and large-scale data processing capabilities.
- **Machine Learning Specialization:** Data analysts are increasingly expected to possess knowledge of machine learning and AI frameworks, as predictive and prescriptive analytics become more essential.

**Takeaway:**
The highest-paying data analyst roles tend to require specialized technical skills in cloud infrastructure, machine learning, and decentralized technologies like blockchain. The convergence of these skills with data analysis expertise leads to higher salaries and greater demand within the field.

### 5. Most Optimal Skills to Learn
By integrating insights from demand and salary data, this analysis aimed to identify skills that were both in high demand and associated with substantial earning potential, thereby providing a strategic focus for skill development.

```sql
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
), average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND (AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
    GROUP BY
        skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count>10
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 25
```
#### *A more streamlined code:*
```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id)>10
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 25;
```

| Skill ID | Skills | Demand | Avg. Salary |
|---|---|---|---|
| 0 | sql | 3083 | 96435 |
| 181 | excel | 2143 | 86419 |
| 182 | python | 1840 | 101512 |
| 183 | tableau | 1659 | 97978 |
| 5 | r | 1073 | 98708 |
| 183 | power bi | 1044 | 92324 |
| 188 | word | 527 | 82941 |
| 196 | powerpoint | 524 | 88316 |
| 186 | sas | 500 | 93707 |
| 7 | sas | 500 | 93707 |
| 61 | sql server | 336 | 96191 |
| 79 | oracle | 332 | 100964 |
| 74 | azure | 319 | 105400 |
| 76 | aws | 291 | 106440 |
| 8 | go | 288 | 97267 |
| 215 | flow | 271 | 98020 |
| 185 | looker | 260 | 103855 |
| 80 | snowflake | 241 | 111578 |
| 199 | spss | 212 | 85293 |
| 92 | spark | 187 | 113002 |
| 22 | vba | 185 | 93845 |
| 189 | sap | 183 | 92446 |
| 198 | outlook | 180 | 80680 |
| 195 | sharepoint | 174 | 89027 |
| 192 | sheets | 155 | 84130 |

#### **Takeaway:**
**SQL** and **Python** remain essential for data analysts due to their widespread application in data manipulation and automation. However, **cloud computing skills** (AWS, Azure, Snowflake) are increasingly critical as companies move to cloud-based infrastructure, offering some of the highest salaries. **Visualization tools** (Tableau, Power BI, Looker) are also highly valuable for interpreting and presenting data. Meanwhile, **real-time data processing platforms** like **Apache Spark** provide the most lucrative opportunities for those managing big data.

Overall, the optimal skill set for data analysts combines strong **data querying**, **programming**, and **cloud computing knowledge** with expertise in **data visualization**.

# Conclusions

### Insights
From the analysis, several general insights emerged:

- **Top-Paying Data Analyst Jobs:** The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, with the highest reaching $650,000!
- **Skills for Top-Paying Jobs:** High-paying data analyst jobs require advanced proficiency in SQL, suggesting it's a critical skill for earning a top salary.
- **Most In-Demand Skills:** SQL is also the most demanded skill in the data analyst job market, making it essential for job seekers.
- **Skills with Higher Salaries:** Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
- **Optimal Skills for Job Market Value:** SQL leads in demand and offers a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Final Thoughts
This comprehensive analysis of the data analyst job market has provided valuable insights for aspiring data analysts. The findings highlight the importance of prioritizing high-demand, high-salary skills to effectively navigate a competitive career path. By focusing on these areas and continuously adapting to emerging trends within the field of data analytics, aspiring professionals can enhance their employability and achieve long-term success.

### Sincere Gratitude
I acknowledge the contributions of Luke Barousse and his YouTube channel. His efforts in disseminating knowledge within the realm of data analysis have undoubtedly aided in the advancement of this field. However, it is imperative to note that his contributions are merely a stepping stone upon which my own endeavors are built.
