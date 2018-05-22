agent_table <- read.csv("https://raw.githubusercontent.com/yusuzech/top-50-user-agents/master/user_agent.csv",stringsAsFactors = F)
agent_list <- agent_table[["User.agent"]]
random_agent <- function(){
    httr::user_agent(sample(agent_list,1))
    }
