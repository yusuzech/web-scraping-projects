library(readr)
library(dplyr)
agent_table <- suppressMessages(suppressWarnings(read_csv("https://raw.githubusercontent.com/yusuzech/top-50-user-agents/master/user_agent.csv") %>%
    select(-X1)))
agent_list <- agent_table[["User agent"]]
random_agent <- function(){
    httr::user_agent(sample(agent_list,1))
    }
