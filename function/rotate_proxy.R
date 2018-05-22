#this function use proxy from proxybonanza
rotate_proxy <- function(proxy_table=my_proxy_table){
    #load proxy table
    if(!exists("proxy_rotation_counter")){
        proxy_rotation_counter <<- 1
    } 
    
    if(proxy_rotation_counter == nrow(proxy_table)+1){
        proxy_rotation_counter <<- 1
    }
    
    current_row <- proxy_rotation_counter
    p_url <- proxy_table$ippack.ip[current_row]
    p_port <- as.integer(proxy_table$ippack.port_http[current_row])
    p_username <- proxy_table$userpackage.login[current_row]
    p_password <- proxy_table$userpackage.password[current_row]
    #counter + 1
    proxy_rotation_counter <<- proxy_rotation_counter + 1
    #set proxy
    return(httr::use_proxy(url=p_url,port=p_port,username=p_username,password=p_password))
    
}
