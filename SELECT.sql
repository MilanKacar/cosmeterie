SELECT 
  ci.Shop_Brand,
  COUNT(DISTINCT ci.Customer_Id) as distinct_customers,
  COUNT(DISTINCT(CONCAT(ci.ShopOrder_ID,ci.Shop_Brand))) as order_count,
  ROUND(COUNT(DISTINCT(CONCAT(ci.ShopOrder_ID,ci.Shop_Brand))) / COUNT(DISTINCT ci.Customer_Id), 2) AS orders_per_active_customer
FROM 
  `niceshops-datawarehouse.consumer_analysis.customer_identification` ci
INNER JOIN 
  `niceshops-datawarehouse.disco.ShopOrder` so
ON 
  ci.Shop_Brand = so.Shop_Brand
AND 
  ci.ShopOrder_ID = so.ShopOrder_ID
WHERE 
  ci.Order_Date >= DATE ("2021-01-01")
AND 
  ci.Order_Date < DATE ("2022-01-01")
AND
  so.ShopOrderPaymentState_Code != 'returned'
AND
  so.ShopOrderState_Code  NOT IN ('new', 'deleted')
AND
  so.ShopOrderType_Code IN ('order_external','order_directcheckout','order')
GROUP BY 1