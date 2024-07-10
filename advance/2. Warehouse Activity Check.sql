/**2. Are all the warehouses currently in use still necessary? 
How can we review warehouses with low or inactive inventory?
**/
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
