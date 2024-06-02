# This covers 'Basic R' in the course Reproducible Research with R and Git
# From slides 1-8 'Learning R w/ R Studio'
# https://docs.google.com/presentation/d/1q0PK_rMCxUelB--Rkk09ZEqrpMk42Wzuv7qeej1pxL4/


# A. Generate Data and Matrices

random_data <- rnorm(100, mean = 50, sd = 10)

non_random_data <- 26:125

data_matrix <- cbind(random_data, non_random_data)


# B. Perform a t-test

t_test_result <- t.test(data_matrix[,1],
                        data_matrix[,2],
                        var.equal = F)

print(t_test_result)


# C. Generating Histograms

hist(data_matrix[,1],
     main = "Histogram of Random Normal Data",
     xlab = "Random Data Values")

hist(data_matrix[,2],
     main = "Histogram of Non-Random Uniform Data",
     xlab = "Non-Random Data Values")

# run all three lines at once for combined histogram
# NOTE: you may need to adjust the size/shape of your viewer for it to look correct

hist(non_random_data, col = "purple", main = "Combined Histogram of Data", xlab = "Data Values", xlim = range(c(non_random_data, random_data)), ylim = c(0, 30), breaks = 20, labels = TRUE, freq = TRUE)
hist(random_data, col = "yellowgreen", add = TRUE, breaks = 20, labels = TRUE, freq = TRUE)
legend("topright", legend = c("Uniform", "Normal"), fill = c("purple", "yellowgreen"))

# NOTE: you can save the image by right-clicking in the "Plots" viewer


# D. String Objects

fruits <- "apple, banana, cherry"
vegetables <- "carrot, asparagus, avocado"

combined_strings <- paste(fruits, vegetables, sep = ", ")

modified_strings <- gsub("a", "", combined_strings)

cat("Original Combined Strings:", combined_strings, "\n")
cat("Modified Strings (without 'a'):", modified_strings, "\n")

