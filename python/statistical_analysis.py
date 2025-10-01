# Direct database connection to pgAdmin
from urllib.parse import quote_plus
import pandas as pd
from sqlalchemy import create_engine
import pandas as pd
import seaborn as sns 
import matplotlib.pyplot as plt
from scipy.stats import pearsonr, f_oneway, chi2_contingency


# connection details (replace with your data)
username = "******"
password = "*******"
host = "localhost"
port = "****"
database = "blinkit"

# URL-encode the password to handle special characters if present e.g @, #
password_encoded = quote_plus(password)

# create connection string with encoded password
engine = create_engine(f"postgresql+psycopg2://{username}:{password_encoded}@{host}:{port}/{database}")

# load loan_analysis table into pandas
df = pd.read_sql("SELECT * FROM BlinkIT", engine)

# Inspect dataset
print(df.info())
print(df.describe())


# ANALYSIS 1
# Sales
sales_stats = df["sales"].agg(["mean", "median", "std", "min", "max"])

# Item Weight
weight_stats = df["Item Weight"].agg(["mean", "median", "std"])

# Item Visibility
visibility_stats = df["Item Visibility"].agg(["mean", "median", "std"])

# Rating
rating_stats = {
    "mean": df["rating"].mean(),
    "mode": df["rating"].mode()[0],
    "distribution": df["rating"].value_counts(normalize=True).to_dict()
}

# Outlet Establishment Year
year_stats = {
    "range": (df["Outlet Establishment Year"].min(), df["Outlet Establishment Year"].max()),
    "most_common": df["Outlet Establishment Year"].mode()[0]
}

print("Sales:\n", sales_stats)
print("\nItem Weight:\n", weight_stats)
print("\nItem Visibility:\n", visibility_stats)
print("\nRating:\n", rating_stats)
print("\nOutlet Year:\n", year_stats)


# ANALYSIS 2

cols = ["sales","Item Visibility","Item Weight","rating"]

# Correlation Matrix + Heatmap
corr = df[cols].corr()
sns.heatmap(corr, annot=True, cmap="coolwarm"); plt.show()

# Scatter Plots
sns.pairplot(df[cols]); plt.show()

# Pearson correlations with p-values
for (x,y) in [("sales","Item Visibility"),("sales","Item Weight"),
              ("sales","rating"),("Item Visibility","Item Weight")]:
    r,p = pearsonr(df[x], df[y])
    print(f"{x} vs {y}: r={r:.3f}, p={p:.3g}")


# ANALYSIS 3

# ANOVA
for cat in ["Outlet Type","Outlet Size","Outlet Location Type"]:
    groups = [g["sales"].values for _,g in df.groupby(cat)]
    f,p = f_oneway(*groups)
    print(f"{cat}: F={f:.3f}, p={p:.3g}")
    sns.boxplot(x=cat, y="sales", data=df); plt.show()

# ANALYSIS 4

# Test 1: Fat Content vs Location Type
ct1 = pd.crosstab(df["Item Fat Content"], df["Outlet Location Type"])
chi1, p1, _, _ = chi2_contingency(ct1)
print("Fat Content vs Location Type:\nChi2 =", chi1, "p =", p1)
print(ct1)

# Test 2: Item Type vs Outlet Type
ct2 = pd.crosstab(df["Item Type"], df["Outlet Type"])
chi2_val, p2, _, _ = chi2_contingency(ct2)
print("\nItem Type vs Outlet Type:\nChi2 =", chi2_val, "p =", p2)

# Heatmap for Test 2
sns.heatmap(ct2, annot=True, fmt="d", cmap="YlGnBu"); plt.show()
