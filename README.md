Financial & Sales Analytics — T-SQL Query Portfolio

A collection of over a dozen of T-SQL queries developed during my time in the publishing industry,
supporting sales reporting, contact management, and revenue analysis across regional and institutional accounts.
Written for SQL Server and designed for day-to-day business intelligence use.


About This Repository

These queries were written against a live publishing CRM and sales relational database.
They supported sales teams, regional managers, and executive stakeholders with actionable
reporting on revenue performance, contact outreach, and advertisement tracking.
All proprietary data has been removed; queries are shared for portfolio and demonstration purposes only.

Tech Stack
Language: T-SQL (Microsoft SQL Server)
Tooling: SQL Server Management Studio (SSMS)

Skills Demonstrated

- Temp tables (#temp) for multi-stage data pipelines across complex joins
- Window functions (ROW_NUMBER() OVER PARTITION BY) to identify first-year records per institution
- Correlated subqueries and EXISTS / NOT EXISTS for exclusion logic (e.g. filtering contacts with prior sales)
- String aggregation via STUFF() and FOR XML PATH('') to pivot multi-row results into single-column summaries
- UNION across multiple temp tables to consolidate institutional and publication-level data
- Parameterized queries using DECLARE variables for reusable, date- and region-configurable reports
- Dynamic string building with WHILE loops for flexible email response generation
- Key filtering using string concatenation (CAST(ins_id AS varchar) + CAST(yea_year AS varchar)) across temp tables
- Custom scalar functions (e.g. dbo.NetSales()) for standardized net revenue calculations
- Date arithmetic (DATEADD, DATEDIFF, YEAR()) for rolling 3-year windows and period-over-period comparisons
- ISNULL / COALESCE for clean output formatting in stakeholder-facing exports
