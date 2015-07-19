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
