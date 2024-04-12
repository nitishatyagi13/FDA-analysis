use db_kaggle;
/*Identifying Approval Trends*/
/*1.Determine the number of drugs approved each year and provide insights into the yearly trends.*/

SELECT count(ApplNo),year(ActionDate) 
FROM regactiondate
 WHERE ActionType = 'AP'
 GROUP by year(ActionDate) ORDER by year(ActionDate) ;
 
 /*2.Identify the top three years that got the highest and lowest approvals
, in descending and ascending order, respectively*/

SELECT count(ApplNo),year(ActionDate) 
FROM regactiondate 
WHERE ActionType = 'AP'
GROUP by year(ActionDate) ORDER by count(ApplNo) desc limit 3;

SELECT count(ApplNo),year(ActionDate)
 FROM regactiondate 
WHERE ActionType = 'AP'
GROUP by year(ActionDate) ORDER by count(ApplNo) asc limit 3;

/*3.Explore approval trends over the years based on sponsors.*/

 SELECT a.SponsorApplicant,count(a.ApplNo),YEAR(b.ActionDate) AS ApprovalYear
   FROM
    Application a left join regactiondate b on a.ApplNo = b.ApplNo
    WHERE ActionDate is not null 
  GROUP BY
    a.SponsorApplicant, YEAR(b.ActionDate)
    ORDER BY 
    a.SponsorApplicant  ;


/* Rank sponsors based on the total number of approvals they received each year between 1939 and 1960.*/

SELECT count(r.ApplNo),SponsorApplicant, rank() over(order by count(ApplNo)) 
FROM regactiondate r inner join application a on r.ApplNo = a.ApplNo
 WHERE  year(r.ActionDate) between 1939 and 1960
 GROUP by SponsorApplicant  ORDER by  count(ApplNo) asc;
 
 /*2: Segmentation Analysis Based on Drug MarketingStatus*/

/*1.Group products based on MarketingStatus. Provide meaningful insights into the segmentation patterns.*/

SELECT count(ApplNo), ProductMktStatus FROM product GROUP by ProductMktStatus;
SELECT count(ApplNo), ProductNo FROM product GROUP by ProductNo;

/*2.Calculate the total number of applications for each MarketingStatus year-wise after the year 2010.*/

SELECT count(a.ApplNo),a.ProductMktStatus FROM product a
Left join regactiondate b
On a.ApplNo = b.ApplNo
Where year(b.ActionDate) >=2010
Group by a.ProductMktStatus;

/*3.Identify the top MarketingStatus with the maximum number of applications and analyze its trend over time.*/

SELECT count(a.ApplNo),a.ProductMktStatus,year(b.ActionDate)
 FROM product a
Left join regactiondate b
On a.ApplNo = b.ApplNo WHERE a.ProductMktStatus = 1
Group by year(b.ActionDate) ORDER by year(b.ActionDate);

/*Analyzing Products*/

/* 1)Categorize Products by dosage form and analyze their distribution*/

 SELECT Dosage , ProductMKTStatus, Count(ApplNo)
 FROM product GROUP by dosage, ProductMktStatus;

/* 2)Calculate the total number of approvals for each dosage form and identify the most successful forms.*/

SELECT Dosage , Count(ApplNo)
 FROM product GROUP by dosage;
 
SELECT Dosage , Count(ApplNo)
 FROM product 
GROUP by dosage ORDER by Count(ApplNo) desc limit 1;

SELECT Form , Count(ApplNo) 
FROM product 
GROUP by Form;

SELECT Form , Count(ApplNo) 
FROM product 
GROUP by Form ORDER by Count(ApplNo) desc limit 1;

/* 3) Investigate yearly trends related to successful forms.*/

 SELECT
    a.Form,count(a.ApplNo),
    YEAR(b.ActionDate) AS ApprovalYear,
	Rank() over ( ORDER BY COUNT(a.ApplNo) DESC ) as R_ANK
  FROM
    Product a left join regactiondate b on a.ApplNo = b.ApplNo 
  GROUP BY
    a.Form, YEAR(b.ActionDate);

/* theraputic classes and approval trend */

/* 1) Analyze drug approvals based on therapeutic evaluation code (TE_Code).*/

SELECT count(ApplNo),TECode
 FROM Product GROUP by TECode 
ORDER by count(ApplNo) desc;


/* 2) Determine the therapeutic evaluation code (TE_Code)
 with the highest number of Approvals in each year.*/
  
SELECT * FROM (  SELECT
    a.TECode,count(a.ApplNo),
    YEAR(b.ActionDate) AS ApprovalYear,
	Rank() over (PARTITION BY YEAR(b.ActionDate) ORDER BY COUNT(a.ApplNo) DESC ) as R_ANK
  FROM
    Product a left join regactiondate b on a.ApplNo = b.ApplNo where TECode is not null
  GROUP BY
    a.TECode, YEAR(b.ActionDate)) a WHERE a.R_ANK = 1;