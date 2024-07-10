/**How can the company's credit policies be evaluated? 
Are there customers with credit issues that need to be addressed?
**/
SELECT 
    c.customerNumber, 
    c.customerName, 
    c.creditLimit, 
    SUM(od.quantityOrdered * p.MSRP) AS totalPurchases
FROM 
    customers c
JOIN 
    orders o ON c.customerNumber = o.customerNumber
JOIN 
    orderdetails od ON o.orderNumber = od.orderNumber
JOIN 
    products p ON od.productCode = p.productCode
GROUP BY 
    c.customerNumber, c.customerName, c.creditLimit
HAVING 
    SUM(od.quantityOrdered * p.MSRP) > c.creditLimit;
