# package pacman allows checking if a package is already installed plus loads it
install.packages('pacman')
library('pacman')

## Check/load packages
p_load('tidyverse',
       'tm',
       'countrycode')

# Wikipedia
## Scraped from Wikipedia 03.05.2024 around 10am CET
df_mottos <- read.csv("./Data/country_mottos.csv", header = TRUE)

## Cleaning up Wikipedia data (base R)
df_mottos$motto_trimmed <- trimws(df_mottos$motto, which = "left")
df_mottos$motto_trimmed <- tolower(df_mottos$motto_trimmed) # lowercase
df_mottos$motto_trimmed <- gsub("[[:punct:]]", "", df_mottos$motto_trimmed)
df_mottos$motto_trimmed <- trimws(df_mottos$motto_trimmed, which = "both")
df_mottos$motto_trimmed <- ifelse(df_mottos$motto_trimmed == "no official motto" | df_mottos$motto_trimmed == "no official national motto", "", df_mottos$motto_trimmed)

stopwords_list <- stopwords(kind = "en")  		# Get English stopwords
df_mottos$motto_clean <- sapply(df_mottos$motto_trimmed, function(line) paste(removeWords(strsplit(line, "\\s+")[[1]], stopwords_list), collapse = " "))
df_mottos$motto_clean <- gsub("\\s+", " ", df_mottos$motto_clean)

## Cleaning up Wikipedia data (tidyverse)
stopwords_list <- stopwords(kind = "en")  		# Get English stopwords

df_mottos <- read.csv("./Data/country_mottos.csv", header = TRUE) %>%
  mutate(motto_trimmed = trimws(tolower(motto), which = "both"),
         motto_trimmed = gsub("[[:punct:]]", "", motto_trimmed),
         motto_trimmed = trimws(motto_trimmed, which = "both"),
         motto_trimmed = ifelse(motto_trimmed == "no official motto" | 
                                motto_trimmed == "no official national motto",
                                "", motto_trimmed),
         motto_clean = sapply(motto_trimmed, function(line) paste(removeWords(strsplit(line, "\\s+")[[1]], stopwords_list), collapse = " ")),
         motto_clean = gsub("\\s+", " ", motto_clean),
         iso3c = countrycode(country, "country.name", "iso3c")
         )



## Find four most common motto words
words_list <- unlist(strsplit(df_mottos$motto_clean, "\\s+"))
word_counts <- sort(table(words_list), decreasing = TRUE)
most_common_words <- names(word_counts)[2:5]      # here first ‘word’ is blank, so ignore

###Getting the most common words back into the df_mottos dataframe

for (word in most_common_words) {
  df_mottos[paste("has", word, sep = "_")] <-
    as.integer(grepl(word, df_mottos$motto_clean))
}

### Add variable to identify countries that have no motto

df_mottos$has_none <- ifelse(df_mottos$motto_clean == "", 1, 0)


# World Bank
## This was run 03.05.2024
df_gdp <- wb_data("NY.GDP.PCAP.KD", start_date = 2020, end_date = 2020)
df_lex <- wb_data("SP.DYN.LE00.IN", start_date = 2020, end_date = 2020)

# Merge data

df <- select(df_mottos, -c(motto, motto_trimmed)) %>%
  left_join(select(df_gdp, c(NY.GDP.PCAP.KD, iso3c)), by = "iso3c") %>%
  left_join(select(df_lex, c(SP.DYN.LE00.IN, iso3c)), by = "iso3c") %>%
  mutate(gdppc_k = NY.GDP.PCAP.KD/1000,
         life_exp = SP.DYN.LE00.IN) %>%
  select(-c(NY.GDP.PCAP.KD,SP.DYN.LE00.IN))

  

