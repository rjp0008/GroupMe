readInFile <- function() {
    json <- fromJSON("54790.json")
    messageList <- json$response$messages
    messageList
}


dateTimeCount <- function(createdAtPosixlt) {
    hours <- 0:23
    hoursCount <- vector(mode = "numeric", length = 24)
    for (date in createdAtPosixlt) {
        posixlt <- as.POSIXlt(date,origin = "1970-1-1")
        hoursCount[posixlt$hour + 1] <-
            hoursCount[posixlt$hour + 1] + 1
        
    }
    data.frame(Hour = hours,MessageCount = hoursCount)
}

messageLengthCounts <- function(messageText) {
    msgLength <- max(nchar(messageText))
    msgCounts <- vector(mode = "numeric",length = (msgLength))
        for (text in messageText) {
        msgCounts[(nchar(text))] <- msgCounts[(nchar(text))] + 1
    }
    data.frame(Length = 1:150,MessageCount = msgCounts[1:150]/msgLength)
}

messageLengthCountByUser <- function(messages) {
    users <- unique(msg$sender_id[msg$sender_id != "system"])
    messageLengths <- vector(mode = "list",length = length(users))
    for (i in 1:length(users)) {
        messageLengths[[i]] <-
            messageLengthCounts(messages$text[messages$sender_id == users[i]])
    }
    messageLengths
}

dateTimeCountByUser <- function(messages) {
    users <- unique(msg$sender_id[msg$sender_id != "system"])
    hourCounts <- vector(mode = "list",length = length(users))
    for (i in 1:length(users)) {
        hourCounts[[i]] <-
            dateTimeCount(msg$created_at[msg$sender_id == users[i]])
    }
    hourCounts
}

plotGroup <- function(dfs) {
    colors <- rainbow(1:length(dfs))
    plot()
}

messageLengths <- function(messageStrings) {
    maxLength <- max(nchar(messageStrings))
    nchars <- vector(mode = "numeric",length = maxLength)
    for (index in 1:length(messageStrings)) {
        nchars[nchar(messageStrings[[index]])] <-
            (nchars[nchar(messageStrings[[index]])] + 1)
    }
    data.frame(1:maxLength,nchars)
}
