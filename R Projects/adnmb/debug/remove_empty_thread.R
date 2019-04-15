#detect and remove empty thread based on file size
files_info <- file.info(str_c("data/thread/",dir("data/thread/")))
#remove file with size smaller than 100(lines get deleted)
files_size <- files_info$size
#
empty_files <- rownames(files_info[files_size<100,])
#remove them
file.remove(empty_files)
