from pathlib import Path
import pandas as pd

# Find the main project directory
BASE_DIR = Path(__file__).resolve().parent.parent

# Locate the raw CSV
DATA_FILE = BASE_DIR / "data" / "raw" / "orders_raw.csv"

# Load the dataset
df = pd.read_csv(DATA_FILE)

print(df.head(10))
print(df.shape)
print(df.isna().sum())
print(df["status"].unique())

df["status"] = df["status"].str.lower().str.strip().fillna("unknown")

print(df["status"].unique())

print()

print("The number of fully duplicated rows is: ", df.duplicated().sum())
print("The number duplicate order id values is: ", df["order_id"].duplicated().sum())
print(df[df.duplicated()])
print()
print(df[df["order_id"].duplicated(keep=False)])

df = df.drop_duplicates()

print(df.shape)

print(df.isnull().sum())

print(df[df["quantity"].isna()])
print(df[df["amount"].isna()])

print()

PRODUCTS_FILE = BASE_DIR / "data" / "raw" / "products_raw.csv"
products_df = pd.read_csv(PRODUCTS_FILE)

print(products_df.head(10))

df.loc[df["order_id"]== 1012, "quantity"] = 3
df.loc[df["order_id"] == 1035, "amount"] = 595

print(df[["quantity", "amount"]].isnull().sum())

print(df.head(20))

df["quantity"] = df["quantity"].astype(int)

print(df.dtypes)

print()

df["order_date"] = pd.to_datetime(df["order_date"], errors="coerce")

print(df["order_date"].dtype)
print(df["order_date"].isna().sum())
print(df.dtypes)
print(df.isnull().sum())

order_items_df = df[["order_id", "product_id", "quantity", "amount"]].copy()
order_items_df.to_csv(
    BASE_DIR / "data" / "cleaned" / "order_items_cleaned.csv",
    index=False
)
df = df.drop(columns=["product_id", "quantity", "amount"])
OUTPUT_FILE = BASE_DIR / "data" / "cleaned" / "orders_cleaned.csv"

df.to_csv(OUTPUT_FILE, index=False)

#-------------------------------
## cleaned cutomers csv
print()

CUSTOMERS_FILE = BASE_DIR /"data"/"raw"/"customers_raw.csv"

customers_df = pd.read_csv(CUSTOMERS_FILE)

print(customers_df.head(30))
print(customers_df.shape)
print(customers_df.isna().sum())

print(customers_df["customer_id"].duplicated(keep = False).sum())

print(customers_df["region"].unique())
print(customers_df.dtypes)

CUSTOMERS_OUTPUT = BASE_DIR / "data" / "cleaned" / "customers_cleaned.csv"

customers_df.to_csv(CUSTOMERS_OUTPUT, index=False)

#-----------------------------------------
#cleaned product csv

PRODUCTS_FILE = BASE_DIR / "data" / "raw" / "products_raw.csv"
products_df = pd.read_csv(PRODUCTS_FILE)

print()
print(products_df.head(8))
print(products_df.shape)
print(products_df.isna().sum())
print(products_df["product_id"].unique())
print(products_df["product_id"].duplicated(keep = False))
print()
print(products_df.dtypes)
print()
print((products_df["unit_price"] >= 0) & (products_df["stock_on_hand"] >= 0))
print()


PRODUCT_OUTPUT = BASE_DIR / "data" / "cleaned" /  "products_cleaned.csv"

products_df.to_csv(PRODUCT_OUTPUT, index=False)

#-------------------------------------------------
## cleaned shipments csv
print()
print()
print()
print()

SHIPMENTS_FILE = BASE_DIR /"data"/"raw"/"shipments_raw.csv"

shipments_df = pd.read_csv(SHIPMENTS_FILE)

print(shipments_df.head(10))
print(shipments_df.shape)
print(shipments_df.dtypes)
print(shipments_df.isna().sum())

shipments_df["promised_date"] = pd.to_datetime(shipments_df["promised_date"], errors="coerce")

shipments_df["delivered_date"] = pd.to_datetime(shipments_df["delivered_date"], errors='coerce')
print()
print(shipments_df.dtypes)
print(shipments_df["shipment_id"].duplicated(keep = False))
print(shipments_df["shipment_id"].duplicated().sum())
print()
print(shipments_df[shipments_df["shipment_id"].duplicated(keep = False)])
print(shipments_df["carrier"].unique())
print()
print(shipments_df.dtypes)
print([shipments_df["order_id"].duplicated(keep = False)])
print(shipments_df["order_id"].duplicated().sum())
print()
print(shipments_df[shipments_df["order_id"].duplicated(keep = False)])
print()
print(shipments_df["delivered_date"].isna().sum())
print(shipments_df[shipments_df["delivered_date"].isna()])
#print(shipments_df.loc(shipments_df["delivered_date"] ==))
print()
print(shipments_df["promised_date"].isna().sum())

print()
shipments_df = shipments_df.drop_duplicates()

print(shipments_df.shape)
print(shipments_df.head())

print(shipments_df[
    shipments_df["delivered_date"] > shipments_df["promised_date"]
])

late = shipments_df["delivered_date"] > shipments_df["promised_date"]

print(late.sum())

print()

SHIPMENTS_OUTPUT = BASE_DIR / "data" / "cleaned" / "shipments_cleaned.csv"

shipments_df.to_csv(SHIPMENTS_OUTPUT, index=False)


# Investigate order 1045 in the original raw data

raw_orders = pd.read_csv("data/raw/orders_raw.csv")

print(raw_orders.loc[raw_orders["order_id"] == 1045])
print()
cleaned_orders = pd.read_csv("data/cleaned/orders_cleaned.csv")

print(cleaned_orders.loc[cleaned_orders["order_id"] == 1045])

print()
# Investigate negative quantity for order 1091, product 4, in raw data
print(raw_orders.loc[
    (raw_orders["order_id"] == 1091) &
    (raw_orders["product_id"] == 4)
])

print()
# Verify negative quantity in the cleaned order items data
cleaned_items = pd.read_csv("data/cleaned/order_items_cleaned.csv")

print(cleaned_items.loc[
    (cleaned_items["order_id"] == 1091) &
    (cleaned_items["product_id"] == 4)
])
print()

# Investigate missing order date for order 1054 in raw data
print(raw_orders.loc[raw_orders["order_id"] == 1054])

print()
# Verify missing order date for order 1054 in cleaned data
print(cleaned_orders.loc[cleaned_orders["order_id"] == 1054])

print()
# Investigate unknown order statuses in the original raw data
print(raw_orders.loc[
    raw_orders["order_id"].isin([1029, 1058, 1070, 1087, 1116, 1145]),
    ["order_id", "status"]
])