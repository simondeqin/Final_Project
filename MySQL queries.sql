CREATE DATABASE IF NOT EXISTS final_project;
SHOW TABLES;
select * from final_project.brk_a; 
select * from final_project.indexes;
select * from final_project.brk_company_lst;
select * from final_project.stock_profile;
select count(Name) from final_project.stock_profile;
select count(Name) from final_project.stock_profile;
select * from final_project.indexes_fillna;
select * from final_project.indexes;
select * from final_project.company_stock_merged_fillna;
select * from final_project.INDEX3_3;
select * from final_project.INDEX3_3;
select brk_a.PRIMARY from final_project.brk_a;
select * from final_project.BRK_A;
select count(Symbol) from final_project.companies_stock;
select count(Date) from final_project.indexes;
select * from final_project.brk_company_holdings;




-- Calculating the 10-Day Moving Average of BRK_A

select * from final_project.BRK_A;
SELECT Date, Close, 
       AVG(Close) OVER (ORDER BY Date ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) AS moving_average_10
FROM final_project.BRK_A;


-- Calculating the Monthly Moving Average of BRK_A
SELECT Date, Close, 
       AVG(Close) OVER (ORDER BY Date ROWS BETWEEN 23 PRECEDING AND CURRENT ROW) AS moving_average_monthly
FROM final_project.BRK_A;


-- Calculating the Quarterly Moving Average of BRK_A
SELECT Date, Close, 
       AVG(Close) OVER (ORDER BY Date ROWS BETWEEN 71 PRECEDING AND CURRENT ROW) AS moving_average_quarterly
FROM final_project.BRK_A;


-- Query1: Listing the three Moving Average Columns in the same table
SELECT Date, Close,
		AVG(Close) OVER (ORDER BY Date ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) AS Moving_Average_10,
	    AVG(Close) OVER (ORDER BY Date ROWS BETWEEN 23 PRECEDING AND CURRENT ROW) AS Moving_Average_monthly,
	    AVG(Close) OVER (ORDER BY Date ROWS BETWEEN 71 PRECEDING AND CURRENT ROW) AS Moving_Average_quarterly
FROM final_project.BRK_A;



-- Query2: Calculating the Total Capitalization of the Companies

select * from final_project.brk_company_holdings;
select Name, Symbol, Value/Stake as Total_Capitalization from final_project.brk_company_holdings
order by Total_Capitalization desc;



-- Query3: Calculating Categorical Data
select * from final_project.stock_profile;
select count(distinct Sector) from final_project.stock_profile;
select count(distinct Industry) from final_project.stock_profile;
select Sector, Industry, avg(Num_Employees) from final_project.stock_profile
group by Sector, Industry
order by avg(Num_Employees) desc;
select Sector, count(distinct Industry) as Industry_Numbers
from final_project.stock_profile
group by Sector
order by count(distinct Industry) desc;



-- Query4: Calculating the Total Capitalization of Each Sector

select count(Symbol) from final_project.brk_company_holdings;
select count(Symbol) from final_project.stock_profile;
select Sector, count(Sector) as Company_Number, sum(Value) as Total_Value
from final_project.stock_profile
inner join final_project.brk_company_holdings using (Symbol)
group by Sector
order by Total_Value desc;



-- Query5: Calculating the Monthly Performance of BRK_A

SELECT LAST_DAY(Date) AS LastDayOfMonth, Close 
from final_project.BRK_A where (Date) in (LAST_DAY(Date));

# Create a Temporary Table istead of Using Subquery
create temporary table Monthly_Performance SELECT LAST_DAY(Date) AS Last_Day_Month, Close 
from final_project.BRK_A where (Date) in (LAST_DAY(Date)); 

select * from final_project.Monthly_Performance;

SELECT
  Last_Day_Month,
  Close AS Stock_Price,
  Close - LAG(Close) OVER (ORDER BY Close) AS Monthly_Gain
FROM Monthly_Performance;





SELECT
  Date AS current_date,
  LAG(Date) OVER (ORDER BY Date) AS previous_date,
  Date - LAG(Date) OVER (partition by YEAR(Date), MONTH(Date) ORDER BY Date) AS gap
FROM final_project.BRK_A;



  
select * from final_project.BRK_A;

SELECT
  MAX(Date) OVER (PARTITION BY YEAR(Date)) AS max_Date_Year,
    MAX(Date) OVER (PARTITION BY YEAR(Date), Quarter(Date)) AS max_Date_Quarter,
      MAX(Date) OVER (PARTITION BY YEAR(Date), MONTH(Date)) AS max_Date_Month,
  # MAX(Date) OVER (PARTITION BY YEAR(Date), MONTH(Date) ORDER BY Date) AS max_value_previous_month,
  Close
FROM
  final_project.BRK_A
# GROUP BY MAX(Date) OVER (PARTITION BY YEAR(Date))
ORDER BY
  Date;
  
  

SELECT
  MAX(Date) OVER (PARTITION BY YEAR(Date)) AS max_Date_Year
FROM
  final_project.BRK_A
ORDER BY
  Date;
  
  
select date_trunc('month', Date) as month
from final_project.BRK_A;











SELECT 
    DATE_TRUNC('month', date_column) AS month,
    DATE_TRUNC('month', date_column) AS first_day,
    (DATE_TRUNC('month', date_column) + INTERVAL '1 MONTH' - INTERVAL '1 DAY') AS last_day,
    EXTRACT(DAY FROM (DATE_TRUNC('month', date_column) + INTERVAL '1 MONTH' - INTERVAL '1 DAY') - DATE_TRUNC('month', date_column)) AS gap_days
FROM 
    table_name
ORDER BY 
    month;

--

SELECT 
    DATE_TRUNC('month', Date) AS month,
    MAX(value_column) AS last_day_value,
    ((SELECT Close 
	  FROM final_project.BRK_A 
	  WHERE DATE_TRUNC('month', Date) = DATE_TRUNC('month', t.last_day)) 
      - 
      (SELECT Close 
	  FROM final_project.BRK_A 
	  WHERE DATE_TRUNC('month', Date) = DATE_TRUNC('month', t.first_day))) AS monthly_performance
FROM (
    SELECT 
        DATE_TRUNC('month', Date) AS first_day
    FROM final_project.BRK_A
    GROUP BY DATE_TRUNC('month', Date)
) t
JOIN table_name ON DATE_TRUNC('month', date_column) = t.first_day
GROUP BY t.first_day
ORDER BY t.first_day;





