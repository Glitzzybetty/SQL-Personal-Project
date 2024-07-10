<h1>Case Study #1 - Analyze Data in a Model Car Database </h1>
<h1>Contents</h1>
<ul>
  <li><a href="#introduction">Introduction</a></li>
  <li><a href="#problemstatement">Project Scenerio</a></li>
  <li><a href="#objective">Project Objective</a></li>
  <li><a href="#database">Database Information</a></li>
  <li><a href="#casestudyquestionsandsolutions">Case Study Questions & Solutions</a></li>
  <li><a href="#bonusquestionsandsolutions">Bonus Questions & Solutions</a></li>
  <li><a href="#keyinsights">Key Insights</a></li>
</ul>

<h2><a name="Introduction">Introduction</a></h1>
<p>As a data analyst at the fictional Mint Classics Company, am helping to analyze data in a relational database with the goal of supporting inventory-related business decisions that lead to the closure of a storage facility.</p>

<h2><a name="problemstatement">Project Scenerio</a></h1>
<p> Mint Classics Company, a retailer of classic model cars and other vehicles, is looking at closing one of their storage facilities. 
To support a data-based business decision, they are looking for suggestions and recommendations for reorganizing or reducing inventory, while still maintaining timely service to their customers. For example, they would like to be able to ship a product to a customer within 24 hours of the order being placed.</p>

<h2><a name="objective">Project Objective</a></h1>
<p>
<ul>1. Explore products currently in inventory.</ul>
<ul>2. Determine important factors that may influence inventory reorganization/reduction.</ul>
<ul>3. Provide analytic insights and data-driven recommendations.</ul>
</p>

<h2><a name="database">Database Information</a></h1>
<p>The Database for this project was initially configured to MySQL pattern, I had to convert it to MSSQL pattern. Re-wrote the table creations, and the data insertions with the order datails containing more that 1000 rows. I used partly AI prompting as additional assistance for ideas. It was QED.</p>
Mint Classic Entity Relationship Diagram (ERD)
<img width="500" alt='MintDB ERD' src= "https://github.com/Glitzzybetty/SQL-Project/assets/130115684/9ca464ac-982a-4d77-80a4-c1077fce2570">

<h1><a name="casestudyquestionsandsolutions">Exploring to understand some Business Demographic Information</a></h1>
<p>It is very important to find out out business demography, customer segments, doing some background checks before attemping to fix underlying problems.</p>
<ol>

  <li><h5>Where are the top five customers aggregations located</h5></li>
	
```sql
-- Top 5 Countries of Mint Classic customers
select top 5
country, 
count(customerNumber) as [Number of Customers],
round(avg(creditLimit),0) as [Average Credit Limit]
from [mintclassics].[dbo].[customers]
group by country 
order by count(customerNumber) desc
```
<h6>Answer:</h6>
<img width="500" alt="Top 5 customers information" src="https://github.com/Glitzzybetty/SQL-Project/assets/130115684/5bb358a7-bae7-4cc0-9e61-bd9c633ce4ce">
<ul>
  <li>The SQL query retrieves the <code>customerNumber</code> shows their <code>country</code> of residents and calculates the average (<code>creditLimit</code>) in each country group they belong to.</li>
  <li>It presents data from the <code>customers</code> table.
  <li>The results are grouped by top 5 <code>country</code>.</li>
  <li>The query then calculates the average <code>creditlimit</code> for each group of customers with the same <code>country</code>.</li>
  <li>Finally, the results are sorted in descending order based on the <code>customerNumber</code> aggregation.</li>
	<li>The findings here shows that there are more customers in the USA</li>
</ul>

<li><h5>Explain MintClassic Employees hierarchy, and their aggregation per location </h5></li>
	
```sql
SELECT 
    e1.jobTitle,
    COUNT(e1.employeeNumber) AS EmployeeCount,
    COALESCE(
        CONCAT(e2.firstName, ' ', e2.lastName),
        'No one' -- This will show 'No one' for the President
    ) AS [Report to Person],

	COALESCE(
        e2.jobTitle,
        'No one' -- This will show 'No one' for the President
    ) AS [Report To Person Job Title],
	COALESCE(
        o.[country],
        'No one' -- This will show 'No one' for the President
    ) AS [Report To Person Country]
FROM 
    [mintclassics].[dbo].[employees] e1
LEFT JOIN 
    [mintclassics].[dbo].[employees] e2 ON e1.reportsTo = e2.employeeNumber
JOIN 
    [mintclassics].[dbo].[offices] o ON  e2.officeCode = o.officeCode
GROUP BY 
    e1.jobTitle,
	e2.jobTitle,
    e2.firstName, 
    e2.lastName,
	 o.[country]
ORDER BY 
    EmployeeCount DESC;
```
<h6>Answer:</h6>
<img width="500" alt="Employee Hierarchy and aggregation per location" src="https://github.com/Glitzzybetty/SQL-Project/assets/130115684/1b7f75cb-bee4-4620-9b29-d5493c971f55">
<ul>
  <li>The SQL query retrieves the <code>JobTitle</code> of Employees, shows the count of<code>EmployeeNumber</code> in that position and the report to person, their jobtitle and their <code>country</code>.</li>
  <li>It presents data from the <code>Employees</code> table, self joins to get report to person and joins with <code>officecode</code> to get the <code>country</code> i.e. location of these staffs.
  <li>The results are grouped by top 5 <code>jobTitle</code> <code>names</code> and <code>country</code>.</li>
  <li>The findings points out that majority of employees were from USA, pointing out the reasons more customers are the largest in US. Also, it was discovered one employee who is a sales rep reports to another sales rep in Japan, some questions needs to be asked the stakeholders, especially the VP sales.</li>
</ul>
</ol>
<h1><a name="casestudyquestionsandsolutions">Advance Questions</a></h1>
<p>Critical Question are being asked to reveal Business problems, so that solution can be readily presented</p>
<ol>
  <li><h5> Are there products with high inventory but low sales? How can we optimize the inventory of these products? </h5></li>
	
```sql
WITH product_sales AS (
    SELECT 
        p.productCode, 
        p.productName, 
        p.quantityInStock,
        ISNULL(SUM(od.quantityOrdered), 0) AS totalQuantitySold,
        ISNULL(SUM(od.quantityOrdered * od.priceEach) / NULLIF(AVG(p.quantityInStock), 0), 1) AS InventoryTurnOverRatio,
        ISNULL(AVG(p.quantityInStock) / NULLIF(SUM(od.quantityOrdered * od.priceEach), 0), 1) AS StockToSalesRatio
    FROM 
        products p
    LEFT JOIN 
        orderdetails od ON p.productCode = od.productCode
    GROUP BY 
        p.productCode, p.productName, p.quantityInStock, p.MSRP
)
SELECT TOP 10
    productCode, 
    productName, 
    quantityInStock, 
    totalQuantitySold,
    InventoryTurnOverRatio, 
    CAST(ROUND(StockToSalesRatio, 2) AS float) AS StockToSalesRatio
FROM 
    product_sales
ORDER BY 
    StockToSalesRatio DESC;
```
<h6>Answer 1:</h6>
<img width="500" alt="Inventory vs Order" src="https://github.com/Glitzzybetty/SQL-Project/assets/130115684/8762c528-af8e-4efd-939a-20c12a740134">
<ul>
<li>The SQL uses <h4> CTE i.e. common Table Expression(product_sales):</h4></li>
<li>Calculates <code>totalQuantitySold</code>, <code>InventoryTurnOverRatio</code>, and <code>StockToSalesRatio</code>.</li>
<li>Uses ISNULL and NULLIF to handle division by zero errors.</li>
<h4>Main Query:</h4>
<li>Selects the top 10 products by <code>StockToSalesRatio</code>.</li>
<li>Orders the results by <code>StockToSalesRatio</code> in descending order to highlight products with high inventory relative to sales.</li> 
<h4>Comments on Key Metrics:</h4>
<li>Inventory Turnover Ratio (ITR): Measures how often inventory is sold and replaced over a period. A higher ITR indicates better performance.</li>
<li>Stock to Sales Ratio (SSR): Compares average inventory to sales. A higher SSR suggests overstocking and potential inefficiencies.</li>
<li>This script identifies products with high inventory but low sales and provide a basis for optimization strategies like targeted promotions, inventory reduction, or restocking adjustments.</li>
</ul>

 <li><h5> Are all the warehouses currently in use still necessary? How can we review warehouses with low or inactive inventory? </h5></li>
	
```sql
WITH warehouse_inventory AS (
    SELECT 
        w.warehouseCode, 
        w.warehouseName, 
		COUNT(DISTINCT o.customerNumber) AS [Number of Active Customers],
        SUM(p.quantityInStock) AS totalInventory,
		ISNULL(SUM(od.quantityOrdered), 0) AS totalQuantityOrdered,
        ISNULL(SUM(od.quantityOrdered * od.priceEach) / NULLIF(AVG(p.quantityInStock), 0), 1) AS InventoryTurnOverRatio,
        ISNULL(AVG(p.quantityInStock) / NULLIF(SUM(od.quantityOrdered * od.priceEach), 0), 1) AS StockToSalesRatio
    FROM 
        warehouses w
    LEFT JOIN 
        products p ON w.warehouseCode = p.warehouseCode
	LEFT JOIN orderdetails od ON p.productCode = od.productCode
	LEFT JOIN orders o ON od.orderNumber = o.orderNumber
    GROUP BY 
        w.warehouseCode, w.warehouseName--, p.quantityInStock, p.MSRP
)
SELECT 
    warehouseCode, 
    warehouseName, 
	[Number of Active Customers],
    totalInventory,
	totalQuantityOrdered,
	round(cast(InventoryTurnOverRatio as float), 2) as InventoryTurnOverRatio,
	round(cast(StockToSalesRatio as float),4) as StockToSalesRatio
FROM 
    warehouse_inventory
--WHERE 
  --  totalInventory < 50;
  ORDER BY StockToSalesRatio DESC;
```
<h6>Answer 2:</h6>
<img width="500" alt="Inventory vs Order" src="https://github.com/Glitzzybetty/SQL-Project/assets/130115684/42a8be54-a5a9-4949-8840-723736057ae3">
<ul>
<li>The SQL uses <h4> CTE i.e. common Table Expression(warehouse_inventory):</h4></li>
<li>Calculates <code>totalQuantityOrdered</code>, <code>InventoryTurnOverRatio</code>, and <code>StockToSalesRatio</code>.</li>
<h4>Main Query:</h4>
<li>Selects <code>warehouseName</code>, <code>Number of Active Customers</code>, <code>totalInventory</code>.</l1>
<li>Orders the results by <code>StockToSalesRatio</code> in descending order to highlight warehouses with high inventory relative to sales.</li> 
<h4>Comments on Key Metrics:</h4>
<li>Highest SSR on the list implies a high amount of inventory relative to sales.</li>
<li>Suggests overstocking, higher holding costs, and potential obsolescence.</li>
<li>May indicate that inventory is not turning over quickly enough, leading to inefficiency.</li>
<li> Highest ITR Indicates high inventory turnover.</li>
<h4>Optimisation Strategy</h4>
<p>To Increase ITR and reduce SSR:</p>
<li> Offer incentives or discounts to move excess inventory.</li>
<li>Slow down or temporarily halt new inventory orders until sales catch up with existing stock.</li>
<li>Analyze the reasons for low sales, such as product relevance, competition, or market demand, and take corrective actions.</li>
</ul>

<li><h5> Is there a relationship between product prices and their sales levels?  How can price adjustments impact sales?  </h5></li>
	
```sql
SELECT Top 10
    p.productCode, 
    p.productName, 
    p.MSRP, cast(round(Avg(od.priceEach), 2) as float) as avgPriceSold,
	Avg(od.priceEach) - p.MSRP as [Price Diff],
    SUM(od.quantityOrdered) AS totalQuantitySold
FROM 
    products p
JOIN 
    orderdetails od ON p.productCode = od.productCode
GROUP BY 
    p.productCode, p.productName, p.MSRP
ORDER BY 
    SUM(od.quantityOrdered) desc;

```
<h6>Answer 3:</h6>
<img width="500" alt="Inventory vs Order" src="https://github.com/Glitzzybetty/SQL-Project/assets/130115684/3e415d16-cfe7-40a0-b726-c9ab91361e01">
<ul>
<li>This query examines the relationship between product prices (MSRP) i.e. Manufacturer suggested Retail Price and sales volumes.</li>
<li>By analyzing the output, the company can identify if higher prices correspond to lower sales and</li>
<li>consider price adjustments to optimize sales volumes.</li>
</ul>
<li><h5> Who are the customers contributing the most to sales? How can we focus sales efforts on these valuable customers? </h5></li>
	
```sql
SELECT TOP 10
    c.customerNumber, 
    c.customerName, 
	c.[country],
    SUM(od.quantityOrdered * p.MSRP) AS totalSales
FROM 
    customers c
JOIN 
    orders o ON c.customerNumber = o.customerNumber
JOIN 
    orderdetails od ON o.orderNumber = od.orderNumber
JOIN 
    products p ON od.productCode = p.productCode
GROUP BY 
    c.customerNumber, c.customerName, c.[country]
ORDER BY 
    totalSales DESC
```
<h6>Answer 4:</h6>
<img width="500" alt="customer sales" src="https://github.com/Glitzzybetty/SQL-Project/assets/130115684/714c9501-93d3-4c39-9075-490dc4c1b55b">
<ul>
<li>This query identifies the top 10 customers by total sales.</li>
<li>Focusing sales efforts on these valuable customers can involve personalized marketing strategies, loyalty programs, and enhanced customer service.</li>
</ul>
</ol>

