# Final dashboard — design and QA

**Final PBIX:** `Supply_Chain_Dashboard_USD_Final.pbix`

**Preserved working version:** `Supply_Chain_Dashboard_USD_Polished.pbix`

Both files are in the same `outputs` directory as this document and `KPI_Measures.md`. The existing documentation files were updated in place; no duplicate documentation was created.

## Final design

The report retains its existing 1600 × 1280 canvas, full-width header, four equal KPI cards, two paired chart rows, full-width inventory chart and footer. It uses the existing Segoe UI typography, chart positions, dimensions, spacing, borders and number formats.

| Element | Final color |
|---|---|
| Header and titles | Dark navy `#152A43` |
| Orders by fulfillment status; product order value | Blue `#4179A5` |
| Pending order status, pending KPI and pending inventory | Amber `#E9A23B` |
| On-time delivery by carrier | Teal `#138F89` |
| **Order value by region bars** | **Muted purple-blue `#7060A8`** |
| Inventory stock on hand | Green `#287A65` |
| Background | Light neutral `#F3F6F9` |
| Cards and chart panels | White |

**Latest change:** only the two bar-color settings in the regional visual changed from `#518F9A` to `#7060A8`. All other report formatting, positions, queries, calculations, data and connections remain unchanged from the preserved working version.

## KPI values and USD formatting

| KPI | Display | Meaning |
|---|---:|---|
| Total Orders | 149 | SUM of the existing order-status view counts |
| Total Recorded Order Value | $37,645 | Existing Total Order Value measure, formatted as USD |
| On-Time Delivery Rate | 55.96% | Existing weighted calculation: 61 on-time / 109 delivered shipments |
| Pending Orders | 26 | Existing pending-status calculation |

USD is the user-defined monetary convention for the synthetic dataset. Recorded order value includes shipped, pending, cancelled and unknown statuses; it is not labeled revenue or recognized sales.

Region and product axes use USD in thousands. One-decimal value labels include **$15.8K**, **$10.0K** and **$10.8K**; K = 1,000. The existing value-label format is `$0,.0"K"`, and the KPI format is `$#,0`. These formats do not change the underlying values. The footer retains **Currency: USD (synthetic data)**.

Carrier labels remain **USPS 60.87%**, **UPS 55.88%** and **FedEx 48.28%** on the existing 0–100% axis. Source rates remain 60.87 / 55.88 / 48.28; literal percent signs are appended for display without multiplying them again. The overall KPI remains a numeric ratio formatted as a percentage.

Inventory retains all eight products and both whole-number series: stock on hand and pending units. No subtraction or availability calculation was introduced.

## Checks completed for this final color-only version

1. Verified the SHA-256 hash of the working PBIX before and after creating the final copy; the working file is unchanged.
2. Compared archive contents: **29 entries are byte-identical**, including the embedded DataModel, connection-related metadata, page definition, all four KPI visuals, all other chart definitions and resources. The regional visual is byte-identical after reversing only its two color replacements. Therefore its query, sorting, labels, position and all other settings are unchanged. PBIX package integrity metadata is excluded from this content comparison.
3. Opened `Supply_Chain_Dashboard_USD_Final.pbix` successfully in Power BI Desktop and visually reviewed it in Fit to Page. Confirmed the purple-blue regional bars and the retained amber, blue, teal and green neighboring visuals. Reviewed the visible KPI values, chart labels, product names, inventory legend and footer.
4. Confirmed **four KPI cards and five charts** remain. The four rendered KPI values are **149**, **$37,645**, **55.96%** and **26**.
5. Compared **all 35 underlying chart values** exposed by Power BI with the original validated values; all match exactly.
6. Reconfirmed the rendered USD examples **$15.8K** and **$10.8K**, and all three carrier percentage labels.
7. Updated `Final_Portfolio_QA.md` and `KPI_Measures.md` in place. The DAX expressions documented in `KPI_Measures.md` are unchanged.

## Validation retained from the prior full USD-polish pass

The earlier pass checked the nine visual queries, visual types and filter configurations after native save; verified byte-identical DataModel, Metadata, Settings and DiagramLayout entries; reviewed clipping in Fit to Page; and checked visual bounds and overlap. These are prior-pass checks, not new tests repeated in the final color-only pass. The exact content comparison above confirms their relevant report settings were preserved.

## Limits

No data refresh, live PostgreSQL connectivity test, SQL/view modification, DAX modification, interaction test, accessibility audit, export-resolution test, publication or GitHub upload was performed in this final pass. The newly packaged final copy was opened for inspection; it was not re-saved through Power BI, to keep non-target report entries byte-identical.
