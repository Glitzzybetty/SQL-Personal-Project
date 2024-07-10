--For each employee, calculate their total sales and rank them within their office.
WITH employee_sales AS (
    SELECT 
        e.employeeNumber, 
        e.officeCode, 
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
        e.employeeNumber, e.officeCode
)
SELECT 
    es.employeeNumber, 
    e.firstName, 
    e.lastName, 
    es.officeCode, 
    es.totalSales, 
    RANK() OVER (PARTITION BY es.officeCode ORDER BY es.totalSales DESC) as salesRank
FROM 
    employee_sales es
JOIN 
    employees e ON es.employeeNumber = e.employeeNumber;
