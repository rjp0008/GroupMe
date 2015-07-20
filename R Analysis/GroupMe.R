readInFile <- function(){
    json <- fromJSON("54790.json")
    messageList <- json$response$messages
    messageList
}


dateTimeCount <- function(createdAtPosixlt){
    hours <- 0:23
    hoursCount <- vector(mode="numeric", length = 24)
    for(date in createdAtPosixlt){
        posixlt <- as.POSIXlt(date,origin = "1970-1-1")
        hoursCount[posixlt$hour+1] <-hoursCount[posixlt$hour+1]+1

    }
    data.frame(Hour = hours,MessageCount = hoursCount)
}

dateTimeCountByUser <- function(messages){
    users <- unique(msg$sender_id[msg$sender_id!="system"])
    hourCounts <- vector(mode = "list",length = length(users))
    for(i in 1:length(users)){
        hourCounts[[i]] <- dateTimeCount(msg$created_at[msg$sender_id==users[i]])
    }
    hourCounts
}

plotGroup<- function(dfs){
    colors <- rainbow(1:length(dfs))
    plot()
}
