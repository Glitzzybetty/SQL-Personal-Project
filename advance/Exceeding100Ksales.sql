/**Calculate the total sales amount for each employee's customers 
and list employees with total sales exceeding $100,000.
**/
WITH employee_sales AS (
    SELECT 
        e.employeeNumber, 
        SUM(od.quantityOrdered * p.MSRP) as totalSales
    FROM 
        employees e
    JOIN 
        customers c ON e.employeeNumber = c.salesRepEmployeeNumber
    JOIN 
        orders o ON c.customerNumber = o.customerNumber
    JOIN 
        orderdetails od ON o.orderNumber = od.orderNumber
    JOIN 
        products p ON od.productCode = p.productCode
    GROUP BY 
        e.employeeNumber
)
SELECT 
    e.employeeNumber, 
    e.firstName, 
    e.lastName, 
    es.totalSales
FROM 
    employees e
JOIN 
    employee_sales es ON e.employeeNumber = es.employeeNumber
WHERE 
    es.totalSales > 100000;
