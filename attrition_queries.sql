Use hr_data;
create table hrdata (Age int, Attrition varchar(10), BusinessTravel varchar(30), DailyRate int, Department varchar(30),
 DistanceFromHome int, Education int,EducationField varchar(30), EmployeeCount int, EmployeeNumber int, 
 EnvironmentSatisfaction int, Gender varchar(10), 
 HourlyRate int, JobInvolvement int, JobLevel int, JobRole varchar(30), JobSatisfaction int, MaritalStatus varchar(20), 
 MonthlyIncome int, MonthlyRate int, NumCompaniesWorked int , Over18 varchar(10), OverTime varchar(10), PercentSalaryHike int, PerformanceRating int,
 RelationshipSatisfaction int, StandardHours int, StockOptionLevel int, TotalWorkingYears int, TrainingTimesLastYear int,WorkLifeBalance int, YearsAtCompany int, YearsInCurrentRole int,
 YearsSinceLastPromotion int,YearsWithCurrManager int);

load data local infile "D:/project2/WA_Fn-UseC_-HR-Employee-Attrition(1).csv"
into table hrdata
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

SELECT department,
       COUNT(employeenumber) AS totalemp,
       COUNT(CASE WHEN attrition='Yes' THEN 1 END) AS leavers,
       (COUNT(CASE WHEN attrition='Yes' THEN 1 END) * 1.0 / COUNT(employeenumber)) * 100 AS attrition_rate_pct
FROM hrdata
GROUP BY department;

SELECT jobrole,
       overtime,
       COUNT(employeenumber) AS totalemp,
       COUNT(CASE WHEN attrition='Yes' THEN 1 END) AS leavers,
       (COUNT(CASE WHEN attrition='Yes' THEN 1 END) * 1.0 / COUNT(employeenumber)) * 100 AS attrition_rate_pct
FROM hrdata
GROUP BY jobrole, overtime
ORDER BY attrition_rate_pct DESC;


SELECT jobrole, totalemp, leavers, attrition_rate_pct, 
       rank() over(order by attrition_rate_pct desc)
FROM (select jobrole,
       COUNT(employeenumber) AS totalemp,
       COUNT(CASE WHEN attrition='Yes' THEN 1 END) AS leavers,
       (COUNT(CASE WHEN attrition='Yes' THEN 1 END) * 1.0 / COUNT(employeenumber)) * 100 AS attrition_rate_pct from hrdata GROUP BY jobrole ) as attritionrate
GROUP BY jobrole
ORDER BY attrition_rate_pct DESC;

select employeenumber, jobrole, yearsatcompany, rank() over (partition by jobrole order by yearsatcompany) from hrdata;

select EmployeeNumber, 
JobRole, MonthlyIncome, JobSatisfaction,
 OverTime, Attrition 
 from hrdata
 where jobsatisfaction<=2 and monthlyincome <(select avg(monthlyincome) from hrdata) and overtime='Yes';