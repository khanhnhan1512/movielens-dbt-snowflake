
<h1 align="center">Movielens DBT Snowflake Warehouse</h1>

<p align="center">
  <a href="README.md">English</a> ·
  <a href="README.vi.md">Tiếng Việt</a>
</p>

This project implements an end-to-end data pipeline processing the [MovieLens 20M Dataset](https://grouplens.org/datasets/movielens/20m/). The goal is to transform raw movie data into a high-quality **Star Schema model optimized for analytics and reporting.

The pipeline ingests raw CSVs from `AWS S3` into `Snowflake`, then utilizes `dbt (data build tool)` to orchestrate transformation, testing, and documentation.

# Table of Contents

# Architecture Overview
![Architecture Diagram](architecture/architecture_diagram.svg)

# Project Structure
```
├── 📁 architecture
├── 📁 images
├── 📁 logs
├── 📁 netflix_dbt
│   ├── 📁 analyses
│   │   └── ⚙️ .gitkeep
│   ├── 📁 dbt_packages
│   ├── 📁 macros
│   │   ├── ⚙️ .gitkeep
│   │   ├── 📄 no_null_columns.sql
│   │   └── 📄 relevance_score_test.sql
│   ├── 📁 models
│   │   ├── 📁 marts
│   │   │   ├── 📁 core
│   │   │   │   ├── 📄 dim_genome_tags.sql
│   │   │   │   ├── 📄 dim_movies.sql
│   │   │   │   ├── 📄 dim_users.sql
│   │   │   │   ├── 📄 fct_genome_scores.sql
│   │   │   │   └── 📄 fct_ratings.sql
│   │   │   └── 📁 more_analysis
│   │   │       └── 📄 mart_movie_releases.sql
│   │   ├── 📁 staging
│   │   │   ├── 📄 stg_genome_scores.sql
│   │   │   ├── 📄 stg_genome_tags.sql
│   │   │   ├── 📄 stg_links.sql
│   │   │   ├── 📄 stg_movies.sql
│   │   │   ├── 📄 stg_ratings.sql
│   │   │   └── 📄 stg_tags.sql
│   │   ├── ⚙️ schema.yml
│   │   └── ⚙️ sources.yml
│   ├── 📁 seeds
│   │   ├── ⚙️ .gitkeep
│   │   └── 📄 seed_movie_release_dates.csv
│   ├── 📁 snapshots
│   │   ├── ⚙️ .gitkeep
│   │   └── 📄 snap_tags.sql
│   ├── 📁 tests
│   │   ├── ⚙️ .gitkeep
│   │   ├── 📄 no_null_col_test.sql
│   │   └── 📄 user_first_rating_before_last_test.sql
│   ├── ⚙️ .gitignore
│   ├── 📝 README.md
│   ├── ⚙️ dbt_project.yml
│   ├── ⚙️ package-lock.yml
│   └── ⚙️ packages.yml
├── 📄 LICENSE
├── 📝 README.md
├── 📝 REAME.vi.md
├── 🐍 main.py
├── ⚙️ pyproject.toml
└── 📄 uv.lock
```

# Technologies Used
| Technology       | Function                                                                                    |
|------------------|---------------------------------------------------------------------------------------------|
| Snowflake        | Data warehouse                                                                |
| dbt              | Data transformation, testing, and documentation tool                                      |
| AWS S3           | Cloud storage for raw data files                                                           |
| SQL              | Data querying and transformation language                                                  |
| Star Schema      | Data modeling technique                                          |

# Key `dbt` Features Implemented

- **Incremental Models**: Used for the massive fct_ratings table (20M+ rows) to optimize warehouse compute costs by processing only new data.

- **Snapshots (SCD Type 2)**: Implemented for tags to track changes in user-generated content over time, preserving historical accuracy.

- **Custom Macros**: Developed reusable logic (e.g., check_valid_score) to apply consistent business rules across multiple models.

- **Testing**:

  - `Generic Tests`: Uniqueness, Not Null, Accepted Values, Relationships.

  - `Singular Tests`: Custom SQL queries to validate complex logic (e.g., first_rated_at <= last_rated_at).

- **Documentation**: Fully documented lineage and column descriptions generated via dbt docs.

# Data Modeling
![Data Flow Diagram](architecture/data_flow.svg)

![Star Schema Diagram](architecture/star_schema.svg)

# Data Testing
You can use `dbt test` to run all tests defined in the project. Below is an example of a successful test run:

![Data Testing](images/pass_test.png)

# Installation and Setup Guide

# ✉️ Contact
Feel free to connect with me on the following platforms:
- Email: khanhnhan012@gmail.com
- [![Facebook](https://img.shields.io/badge/Facebook-1877F2?style=for-the-badge&logo=facebook&logoColor=white)](https://www.facebook.com/nguyen.khanh.nhan.905779)
- [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/nhan-nguyen-b22023260/)