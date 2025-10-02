import pandas as pd
import sqlite3

excel_file = "Grocery-Data.xlsx"
db_file = "grocery_data2.db"

# connect to db
conn = sqlite3.connect(db_file)
cursor = conn.cursor()


# load excel sheets into dict of dataframes
sheets = {
    "store": pd.read_excel(excel_file, sheet_name="store"),
    "product": pd.read_excel(excel_file, sheet_name="product"),
    "receipt": pd.read_excel(excel_file, sheet_name="receipt"),
    "web_session": pd.read_excel(excel_file, sheet_name="web_session"),
    "line_item": pd.read_excel(excel_file, sheet_name="line_item"),
}

# clean each dataframe
for name, df in sheets.items():
    # drop manually added index column
    if "index" in df.columns:
        df.drop(columns=["index"], inplace=True)

# insert into database
for name, df in sheets.items():
    df.to_sql(name, conn, if_exists="append", index=False)

#store_df.to_sql("store", conn, if_exists="append", index=False)
#product_df.to_sql("product", conn, if_exists="append", index=False)
#receipt_df.to_sql("receipt", conn, if_exists="append", index=False)
#web_session_df.to_sql("web_session", conn, if_exists="append", index=False)
#line_item_df.to_sql("line_item", conn, if_exists="append", index=False)

conn.commit()
conn.close()
print("Database populated successfully.")
