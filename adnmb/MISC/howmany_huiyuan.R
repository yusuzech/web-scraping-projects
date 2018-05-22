# #V1
# uids <- dataset_thread$post_uid
# isnot_huiyuan <- str_detect(uids,pattern = "^[a-zA-Z0-9_.-]*$")
# huiyuan_full <-uids[!isnot_huiyuan]
# huiyuan <- character(0)
# for(item in huiyuan_full){
#     if(str_detect(item,pattern = "^[a-zA-Z0-9_.-]{7,8} - ")){
#         huiyuan <- append(huiyuan,str_sub(item,start = 11))
#     } else{
#         huiyuan <- append(huiyuan,item)
#     }
# }
# unique(huiyuan)
# 
# which(str_detect(uids,"font"))
# dataset_thread[208258,]
# #best uid
# # 6188401 <font color= 2015-06-12 20:48:24 >>No.6172540来张白丝吧|∀` )        18 3229404       绘画涂鸦(二创)
# #18 page


#V2
uids <- dataset_thread$post_uid
isnot_huiyuan <- str_detect(uids,pattern = "^[a-zA-Z0-9_.-]*$")
huiyuan_full <-uids[!isnot_huiyuan]

huiyuan <- character(0)
for(item in huiyuan_full){
    if(!str_detect(item,pattern = "^[a-zA-Z0-9_.-]{7,8} - ")){
        huiyuan <- append(huiyuan,item)
    } 
}
suffix_remove <- str_extract(huiyuan,".*(?= - .*尐哙員$)")
true_huiyuan <- c(suffix_remove[!is.na(suffix_remove)],huiyuan[is.na(suffix_remove)])
#remove special case
true_huiyuan2 <- sort(unique(true_huiyuan[true_huiyuan!="<font color="]))
