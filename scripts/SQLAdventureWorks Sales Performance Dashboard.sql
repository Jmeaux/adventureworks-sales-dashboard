SELECT
    CONVERT(char(7), soh.OrderDate, 120) AS YearMonth,   -- yyyy-mm
    st.[Name] AS TerritoryName,
    COUNT(DISTINCT soh.SalesOrderID) AS Orders,
    SUM(soh.TotalDue) AS Sales,
    CAST(SUM(soh.TotalDue) / NULLIF(COUNT(DISTINCT soh.SalesOrderID), 0) AS decimal(18,2)) AS AvgOrderValue
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesTerritory AS st
    ON soh.TerritoryID = st.TerritoryID
CROSS JOIN (
    SELECT MAX(OrderDate) AS MaxOrderDate
    FROM Sales.SalesOrderHeader
) AS md
WHERE
    soh.OrderDate >= DATEADD(MONTH, -12, md.MaxOrderDate)
GROUP BY
    CONVERT(char(7), soh.OrderDate, 120),
    st.[Name]
ORDER BY
    YearMonth,
    TerritoryName;
