use project; 
show tables;
select * from finance_1;
select * from finance_2;
desc finance_1;
desc finance_2;
alter table finance_1
modify column issue_d date;

##-------total Customers------------
SELECT COUNT(*) AS total_customers
FROM finance_1;
SELECT COUNT(*) AS total_customers
FROM finance_2;

###-----Total loan amount-----------
select sum(loan_amnt) AS total_loan_amount
from finance_1;

##------- Average Annual income------------------
select AVG(annual_inc) AS average_annual_income
from finance_1;

##---------Total Pyment By customers-------------
select sum(total_pymnt) AS total_payment_by_customers
from finance_2;

##------KPI-1---Year wise loan amount Stats------
select year (issue_d) as issue_year,concat('$',sum(loan_amnt)) as total_amount
from finance_1
group by issue_d
order by issue_d;

#KPI-2-----Grade and sub grade wise revol_bal------ 
 select f1.grade,f1.sub_grade,sum(f2.revol_bal) as revolving_bal
from finance_1 as f1 inner join finance_2 as f2
on f1.id=f2.id group by f1.grade,f1.sub_grade order by grade;

#KPI-3--------Total Payment for Verified Status Vs Total Payment for Non Verified Status----------
select f1.verification_status,sum(f2.total_pymnt) as total_payment
from finance_1 as f1 inner join finance_2 as f2
on f1.id = f2.id
group by f1.verification_status;

#KPI-4------------State wise and last_credit_pull_d wise loan status------------
 SELECT f1.addr_state, f2.last_credit_pull_d, f1.loan_status
FROM finance_1 f1
JOIN finance_2 f2 ON f1.id = f2.id
order by addr_state;

#KPI-5-------------Home ownership Vs last payment date stats------------
select  year(f2.last_pymnt_d)Payment_year, month(f2.last_pymnt_d)payment_month,f1.home_ownership, count(f1.home_ownership)home_ownership
from finance_1 as f1 inner join finance_2 as f2
on f1.id=f2.id
group by (f2.last_pymnt_d), (f2.last_pymnt_d), f1.home_ownership
order by payment_year;

#KPI-6--------------Net interest margin-------------
SELECT EXTRACT(YEAR FROM issue_d) AS year,
    (SUM(installment * term) - SUM(int_rate * funded_amnt_inv)) / AVG(funded_amnt_inv) AS Net_interest_margin
FROM finance_1
GROUP BY EXTRACT(YEAR FROM issue_d);

#KPI-7--------------Cost to income ratio-------------
SELECT EXTRACT(YEAR FROM issue_d) AS year,
    (SUM(dti) / SUM(annual_inc)) * 100 AS cir
FROM finance_1
GROUP BY EXTRACT(YEAR FROM issue_d);


#KPI-8--------------Return on assets-------------
SELECT EXTRACT(YEAR FROM issue_d) AS year,
    SUM(annual_inc) / AVG(funded_amnt) AS roa
FROM finance_1
GROUP BY EXTRACT(YEAR FROM issue_d);

