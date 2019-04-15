#give a list of tasks to complete, instead of retry immediately after failures, this template stores failed tasks and retry them 
#after all other tasks are completed.
#This template is useful when making request to websites.

#initialize user input-----------
tasks <- 1:10 # tasks
all_out <- c() #store output

#initialize template input-----------
complete_flag <- F
try_later <- c()
failed_after_all_tries <- c()
#try times ---------------
max_try <- 3
tried <- 1
while (complete_flag == F & tried <= max_try) {
  #the list of tasks should be able to be put into a for loop
  for(task in tasks){
    #do something below ----------------------------------------
    out <- tryCatch(log(runif(1,-task,task)),
                    warning=function(e){
                      message(conditionMessage(e))
                      return(NULL)
                    })
    #do something above ---------------------------------------
    #capture output, if output is null, add it to try later
    if(is.null(out)){
      try_later <- c(try_later,task)
      cat("task ",match(task,tasks)," in ", length(tasks)," failed\n")
    } else {
      #if succussful, do something below ---------------
      all_out <- c(all_out,out)
      #if succussful, do something above ---------------
      cat("task ",match(task,tasks)," in ", length(tasks)," completed.\n")
    }
    Sys.sleep(1)
  }
  #optional,print text that shows progress after for loop -------------
  remaing_try_text <- glue::glue("Time tried {tried} ; tasks count: {tasks_count} ; failed count {failed_count}; Time: {time_now}",
                                 tasks_count = length(tasks),
                                 failed_count = length(try_later),
                                 time_now = Sys.time())
  cat(remaing_try_text,"\n")
  tried <- tried + 1
  
  if(length(try_later) == 0){
    #if all tasks are completed, exit while loop
    complete_flag <-  T
    cat("No failed tasks\n")
  } else {
    if(tried <= max_try){
      tasks <- try_later
      #reset try_later
      try_later <- c()
    } else {
      #if after max try, some still fail, record them and exit loop
      failed_after_all_tries <- c(failed_after_all_tries,try_later)
      #reset try_later
      try_later <- c()
    }
  }
}

text_final <- glue::glue("After {max_try} tries, still {failed_count} fails, they are {failed_items}",
                         failed_count=length(failed_after_all_tries),
                         failed_items=stringr::str_c(failed_after_all_tries,collapse=","))
cat(text_final,"\n")
