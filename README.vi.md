<h1 align="center">Movielens DBT Snowflake Warehouse</h1>

<p align="center">
  <a href="README.md">English</a> ·
  <a href="README.vi.md">Tiếng Việt</a>
</p>

Dự án này triển khai một data pipeline end-to-end để xử lý [MovieLens 20M Dataset](https://grouplens.org/datasets/movielens/20m/). Mục tiêu là chuyển đổi dữ liệu phim thô thành mô hình **Star Schema** chất lượng cao, được tối ưu hóa cho analytics và reporting.

Pipeline thực hiện ingest các file CSV thô từ `AWS S3` vào `Snowflake`, sau đó sử dụng `dbt (data build tool)` để điều phối quá trình transformation, testing và documentation.

# Tổng Quan Kiến Trúc
![Architecture Diagram](architecture/architecture_diagram.svg)

Pipeline tuân theo quy trình **ELT (Extract, Load, Transform)** hiện đại, đảm bảo dữ liệu thô được bảo toàn trong khi các derived models được tối ưu hóa cho hiệu suất.
1. Ingestion (Extract & Load)
* **Source:** MovieLens 20M dataset (CSV) được upload lên một **AWS S3** bucket, đóng vai trò là Data Lake.
* **Loading:** Snowflake tương tác với S3 thông qua một **External Stage**. Dữ liệu thô được load trực tiếp vào schema `raw` bằng lệnh `COPY INTO`. Tại giai đoạn này, định dạng gốc của dữ liệu được giữ nguyên.
2. Staging Layer (Transformation - Part 1)
* **Orchestration:** **dbt** lấy dữ liệu từ schema `raw`.
* **Cleaning & Standardization:**
    * Tên cột được đưa về dạng `snake_case`.
    * Unix timestamps được ép kiểu (cast) sang Snowflake `TIMESTAMP_LTZ`.
    * **Complex Parsing:** Sử dụng Regex để trích xuất năm phát hành từ tiêu đề phim và chuyển đổi chuỗi thể loại (genre) ngăn cách bằng dấu gạch đứng thành kiểu dữ liệu `ARRAY` trong Snowflake để query linh hoạt hơn.
3. Marts Layer (Transformation - Part 2)
* **Modeling:** Dữ liệu được tổ chức lại thành **Star Schema** bao gồm các bảng Fact và Dimension.
* **Optimization:**
    * **Incremental Loading:** Áp dụng cho bảng `fct_ratings` (hơn 20 triệu dòng) để chỉ xử lý các bản ghi mới hoặc bản ghi được cập nhật, giúp giảm đáng kể chi phí tính toán.
    * **Surrogate Keys:** Được tạo bằng `dbt_utils.generate_surrogate_key()` để đảm bảo primary keys duy nhất trên toàn bộ mô hình.
* **History Tracking:** **dbt Snapshots** được sử dụng cho dataset `tags` để triển khai **SCD Type 2 (Slowly Changing Dimensions)**, cho phép theo dõi hành vi gắn tag của người dùng thay đổi như thế nào theo thời gian.
4. Data Quality (Testing)
* Trước khi bất kỳ dữ liệu nào được promote lên các production schemas, nó phải vượt qua một bộ automated tests (Uniqueness, Not Null, Referential Integrity, và Custom Logic) được định nghĩa trong `schema.yml` và thư mục `tests/`.

# Câu Trúc Dự Án
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

# Công Nghệ Sử Dụng
| Technology       | Function                                                                                    |
|------------------|---------------------------------------------------------------------------------------------|
| Snowflake        | Data warehouse                                                                              |
| dbt              | Công cụ data transformation, testing, và documentation                                      |
| AWS S3           | Cloud storage cho các file dữ liệu thô                                                      |
| SQL              | Ngôn ngữ truy vấn và chuyển đổi dữ liệu                                                     |
| Star Schema      | Kỹ thuật data modeling                                                                      |

# Các Tính Năng `dbt` Chính Đã Triển Khai

- **Incremental Models**: Sử dụng cho bảng fct_ratings khổng lồ (hơn 20 triệu dòng) để tối ưu chi phí compute của warehouse bằng cách chỉ xử lý dữ liệu mới.

- **Snapshots (SCD Type 2)**: Triển khai cho tags để theo dõi sự thay đổi nội dung do người dùng tạo theo thời gian, bảo toàn tính chính xác của lịch sử dữ liệu.

- **Custom Macros**: Phát triển logic tái sử dụng (ví dụ: check_valid_score) để áp dụng các business rules nhất quán trên nhiều models.

- **Testing**:

  - `Generic Tests`: Uniqueness, Not Null, Accepted Values, Relationships.

  - `Singular Tests`: Custom SQL queries để validate các logic phức tạp (ví dụ: first_rated_at <= last_rated_at).

- **Documentation**: Lineage và mô tả cột được tạo đầy đủ thông qua dbt docs.

# Data Modeling
![Data Flow Diagram](architecture/data_flow.svg)

![Star Schema Diagram](architecture/star_schema.svg)

# Data Testing
Bạn có thể dùng `dbt test` để chạy tất cả các tests được định nghĩa trong project. Dưới đây là ví dụ về một lần chạy test thành công:

![Data Testing](images/pass_test.png)

# Hướng Dẫn Cài Đặt và Thiết Lập
### Yêu cầu tiên quyết
- Python 3.10
- Cài đặt `uv` package manager
- `dbt-snowflake` adapter 1.9.0
- Tài khoản Snowflake
- AWS S3 bucket chứa MovieLens dataset

### Thiết lập trên AWS S3
1. Tạo một S3 bucket (ví dụ: `movielens-dbt-bucket`).
2. Upload các file CSV của MovieLens 20M dataset vào bucket.
3. Tạo một IAM user `snowflakeuser` với quyền `attach policies directly` là `AmazonS3FullAccess`.
4. Lưu lại `Access Key ID` và `Secret Access Key` của IAM user đó.
### Thiết lập trên Snowflake
1. Tạo role, DW, database, schemas, `dbt` user, và cấp các đặc quyền cần thiết.
2. Tạo stage để kết nối Snowflake với S3 bucket sử dụng credential của IAM user.
3. Load dữ liệu thô từ S3 vào schema `raw` bằng lệnh `COPY INTO`.
![Snowflake Setup](./images/create_snowflake_view_by_dbt.png)
### Thiết lập dbt Project
1. Clone repository này.
2. Đồng bộ dependencies sử dụng:
    ```bash
    uv sync
    ```
3. Cấu hình file `profiles.yml` với thông tin kết nối Snowflake như bạn đã thiết lập trước đó.
4. Chạy các lệnh dbt theo thứ tự:
   - Cập nhật `dbt` packages:
     ```bash
     dbt deps
     ```
   - Tải dữ liệu seed:
     ```bash
     dbt seed
     ```
   - Chạy tất cả models: 
     ```bash
     dbt run
     ```
   - Chạy snapshots:
     ```bash
     dbt snapshot
     ```
   - Chạy tests:
     ```bash
     dbt test
     ```
   - Tạo documentation:
     ```bash
     dbt docs generate
     dbt docs serve
     ```
5. Khám phá documentation đã tạo trên trình duyệt.
![DBT Docs](./images/dbt_docs_ui.png)
![DBT Lineage](./images/dbt_lineage_graph.png)
# ✉️ Liên hệ
- Email: khanhnhan012@gmail.com
- [![Facebook](https://img.shields.io/badge/Facebook-1877F2?style=for-the-badge&logo=facebook&logoColor=white)](https://www.facebook.com/nguyen.khanh.nhan.905779)
- [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/nhan-nguyen-b22023260/)