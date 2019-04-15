write_2_db <- function(x,db_path,table_name){
    library(RSQLite)
    library(tidyverse)
    con <- dbConnect(SQLite(),db_path)
    if(dbExistsTable(con,table_name)){
        dbWriteTable(con,table_name,x,append=T)   
    } else {
        dbWriteTable(con,table_name,x) 
    }
    
    dbDisconnect(con)    
}