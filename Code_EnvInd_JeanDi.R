#install.packages("COINr")
library(readxl)
library(COINr)

# upload de iData for year 2000 and 2020
iData_2000 <- read_excel("EI_COINr_input.xlsx", sheet = 1)  # sheet = 1 data for year 2000
iData_2020 <- read_excel("EI_COINr_input.xlsx", sheet = 2)  # sheet = 2 data for year 2020

# upload de iMeta for both year 2000 and 2020
iMeta <- read_excel("EI_COINr_input.xlsx", sheet = 3)  # sheet = 3 used for iMeta by both years


# Let us build coin for both year
EI_2000 <- new_coin(iData_2000, iMeta)
EI_2020 <- new_coin(iData_2020, iMeta)

# Let us see how it looks like
plot_framework(EI_2000)
plot_framework(EI_2020)
# NB : Since they are using the same iMeta, the framework will be the same


# Some statistics analysis before seeing the correlation among indicators
get_stats(EI_2000, dset = "Raw") |>
  DT::datatable(rownames = F)

get_stats(EI_2020, dset = "Raw") |>
  DT::datatable(rownames = F)


# Correlation plot among indicators
plot_corr(EI_2000, dset = "Raw", grouplev = 3, box_level = 2, use_directions = TRUE,
          main = "Correlation Matrix of Environmental Indicators (2000)")
plot_corr(EI_2020, dset = "Raw", grouplev = 3, box_level = 2, use_directions = TRUE,
          main = "Correlation Matrix of Environmental Indicators (2020)")
# NB : Since they are using differents iData, the correlation may be differents for some indicators


# Data treatment using a standard Winsorisation approach
EI_2000 <- qTreat(EI_2000, dset = "Raw", winmax = 5)
EI_2020 <- qTreat(EI_2020, dset = "Raw", winmax = 5)


# We can see what data treatment has been applied
EI_2000$Analysis$Treated$Dets_Table |>
  signif_df() |>
  DT::datatable(rownames = F)

EI_2020$Analysis$Treated$Dets_Table |>
  signif_df() |>
  DT::datatable(rownames = F)


# Data normalization : Min-Max normalization by default
EI_2000 <- qNormalise(EI_2000, dset = "Treated")
EI_2020 <- qNormalise(EI_2020, dset = "Treated")


# We can confirm the normalized data by a histograms plot
plot_dist(EI_2000, dset = "Normalised", iCodes = "EI", Level = 1, type = "Dot")
plot_dist(EI_2020, dset = "Normalised", iCodes = "EI", Level = 1, type = "Dot")


#Finally we can aggregate the index using "arithmetic mean"
EI_2000 <- Aggregate(EI_2000, dset = "Normalised", f_ag = "a_amean")
EI_2020 <- Aggregate(EI_2020, dset = "Normalised", f_ag = "a_amean")


# Access to the calculated result 
get_results(EI_2000, dset = "Aggregated", tab_type = "Full") |>
  DT::datatable(rownames = F)

get_results(EI_2020, dset = "Aggregated", tab_type = "Full") |>
  DT::datatable(rownames = F)


#----------------------------------

# Get the data frames
results_2000 <- get_results(EI_2000, dset = "Aggregated", tab_type = "Full")
results_2020 <- get_results(EI_2020, dset = "Aggregated", tab_type = "Full")

# Export to CSV
write.csv(results_2000, "EI_2000_Aggregated_Results.csv", row.names = FALSE)
write.csv(results_2020, "EI_2020_Aggregated_Results.csv", row.names = FALSE)

#----------------------------------

# Visualisation of results

# By bar chart
plot_bar(EI_2000, dset = "Aggregated", iCode = "EI", stack_children = TRUE)
plot_bar(EI_2020, dset = "Aggregated", iCode = "EI", stack_children = TRUE)


