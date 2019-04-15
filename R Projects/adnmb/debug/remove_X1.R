#remove "X1"
remove_X1 <- function(file_path){
    csvfile <- read_csv(file_path) %>% select(-X1)
    write.csv(x = csvfile,file = file_path,row.names = FALSE)
}
