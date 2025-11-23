## Notes
- Kết quả khi chạy 1 model dbt sẽ tạo ra 1 view và nó được lưu lên snowflake
![image](./images/create_snowflake_view_by_dbt_.png)
- To use the function `dbt_utils.generate_surrogate_key` we must have DBT packages. They are collections of models, macros, and tests that can be reused across projects.
- To use external packages, create a packages.yml file in your project root
- Install the packages using:
  ```bash
  dbt deps
  ```
- model -> seeds -> sources -> snapshots -> testing -> documentation -> macros -> analyses
- all documentation of this project can be found by running:
  ```bash
  dbt docs generate
  dbt docs serve
  ```
![image](./images/dbt_lineage_graph.png)
- Sau khi xong hết, nếu ta muốn analysis thêm để visualize, ad-hoc query,... thì ta có thể tạo 1 file sql trong folder analyses. Sau đó chạy lệnh:
  ```bash
  dbt compile
  ```
  Kết quả sẽ được lưu trong folder target/compiled/netflix_dbt/analyses. Ta có thể copy đoạn query trong file sql đó để chạy trực tiếp trên snowflake.
