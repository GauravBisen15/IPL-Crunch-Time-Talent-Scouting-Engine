# IPL Crunch-Time Talent Scouting Engine

## Project Overview
An enterprise-grade SQL-based analytical system designed to identify elite cricket talent for high-pressure scenarios (Death Overs, 15th-20th over). By analyzing structured ball-by-ball match data, this engine filters high-impact finishers and clutch death-over bowlers to optimize team composition strategies for player auctions.

## Core Features & Architecture
* **Performance Tuning:** Optimized data schema sizes and data type stabilization for lookup performance.
* **Modular Analytical Interfaces:** Engineered reusable Virtual Views utilizing multi-CTEs (Common Table Expressions) and aggregation.
* **Auction Strategy Logic:** Implemented advanced Inner Joins with parameter filters (Strike Rate > 140.0, Economy Rate < 8.5) to isolate elite match-winners.

## Tech Stack
* **Database Management System:** MySQL
* **Advanced SQL Concepts:** Common Table Expressions (CTEs), Subqueries, Views, and Inner Joins
* **Database Optimization:** Data Type Stabilization and Query Optimization

## File Structure
* `ProjectSql.sql` - Main SQL production script containing schema modifications, CTE metrics generation, and auction logic execution.
