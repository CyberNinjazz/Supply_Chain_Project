# KPI measures

Final dashboard: **Supply_Chain_Dashboard_USD_Final.pbix**. The working **Supply_Chain_Dashboard_USD_Polished.pbix** is preserved.

All four cards use model measures rather than fixed values.

```dax
Total Orders = SUM('public vw_order_status'[total_orders])

Total Order Value = SUM('public vw_regional_sales'[total_order_value])

On-Time Delivery Rate =
DIVIDE(
    SUM('public vw_carrier_performance'[on_time_shipments]),
    SUM('public vw_carrier_performance'[delivered_shipments])
)

Pending Orders =
CALCULATE(
    SUM('public vw_order_status'[total_orders]),
    'public vw_order_status'[status] = "pending"
)
```

Validated values: Total Orders **149**; Total Recorded Order Value **$37,645**; On-Time Delivery Rate **55.96%** (61 / 109); Pending Orders **26**. The displayed title is Total Recorded Order Value; the underlying DAX measure remains named Total Order Value. USD is the user-defined currency for the synthetic dataset. Recorded order value includes shipped, pending, cancelled and unknown statuses; it is not labeled revenue or recognized sales. The rate remains a numeric ratio, formatted as a percentage on its card. Measures respond according to the existing model relationships and applicable filters.

The regional and product charts display USD in thousands, for example **$15.8K** and **$10.8K**. Their custom value-label format is `$0,.0"K"`; the order-value card uses `$#,0`. These are visual formats, not changes to the measure expressions.

The final dashboard retains four KPI cards and five charts. The latest pass changes only the regional bars to **#7060A8**. All other chart colors, positions, number formats, DAX, SQL connections, relationships and underlying data are preserved. No refresh, publication or live SQL connectivity test was performed.
