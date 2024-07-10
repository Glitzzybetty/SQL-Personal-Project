/**Find the total number of products each customer has ordered and rank the customers
based on the number of products ordered. Streamlining to Top 10 
**/
SELECT TOP 10
    c.customerNumber, 
    c.customerName, 
    SUM(od.quantityOrdered) as totalProductsOrdered, 
    RANK() OVER (ORDER BY SUM(od.quantityOrdered) DESC) as rank
FROM 
    customers c
JOIN 
    orders o ON c.customerNumber = o.customerNumber
JOIN 
    orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY 
    c.customerNumber, c.customerName;
