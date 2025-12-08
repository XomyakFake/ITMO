#pip install polars
#pip install fastexcel
import polars as pl

df = pl.read_excel("Inflabs/lab5/lab5.xlsx")

df.columns = [chr(65 + i) for i in range(df.shape[1])]

rows = df.slice(2, 12)

cols = [c for c in df.columns[:25] if c not in ("E", "F")]
chunk = rows.select(cols)

pl.Config.set_tbl_rows(1000)
pl.Config.set_tbl_cols(100)
print(chunk)