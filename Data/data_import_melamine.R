df_melamine <- readxl::read_xlsx(here::here("Data", "Survey deutsch (réponses).xlsx"))
set.seed(90120)
df_melamine <- df_melamine[sample(nrow(df_melamine), 100), ]

write.csv(df_melamine, here::here("Data", "df_melamine.csv"), row.names = F, fileEncoding = "UTF-8")
 