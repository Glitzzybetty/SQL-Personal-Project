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
    ) AS [Report To Person Job Title]
FROM 
    [mintclassics].[dbo].[employees] e1
LEFT JOIN 
    [mintclassics].[dbo].[employees] e2 ON e1.reportsTo = e2.employeeNumber
GROUP BY 
    e1.jobTitle,
	e2.jobTitle,
    e2.firstName, 
    e2.lastName
ORDER BY 
    EmployeeCount DESC;