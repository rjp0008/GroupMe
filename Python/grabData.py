import sys
import json
import os
import time
import requests
import matplotlib.pyplot as plt
import pandas
import numpy as np

def getLatestMessages(upToId):
    last = ""
    while True:
        url = "https://api.groupme.com/v3/groups/3000143/messages?token=APIKEY&limit=100"
        if last != "":
            url += "&before_id=" + last
        try:
            data = requests.get(url).json()
            with open("messagestemp.json",'ab') as f:
                for item in (data['response']['messages']):
                    last = str(item['id'])
                    if last == upToId:
                        return
                    f.write((json.dumps(item)+"\n").encode(sys.stdout.encoding, errors='replace'))
        except json.decoder.JSONDecodeError:
            print("done")

def combineNewWithOld():
    os.rename("messages.json","messagesold.json")
    with open("messages.json",'w') as output:
        with open("messagestemp.json",'r') as lastestFile:
            output.writelines(lastestFile.readlines())
        with open("messagesold.json") as oldData:
            output.writelines(oldData.readlines())
    time.sleep(1)
    if os.path.isfile("messagestemp.json"):
        os.remove("messagestemp.json")
    if os.path.isfile("messagesold.json"):
        os.remove("messagesold.json")


def getLastMessageIdFromFile():
    with open("messages.json",'r') as f:
        firstLine = f.readline()
        jsonObj = json.loads(firstLine)
        return (jsonObj["id"])

def dataFrame():
    with open('messages.json', 'r') as f:
        data = f.readlines()
    data = map(lambda x: x.rstrip(), data)
    data_json_str = "[" + ','.join(data) + "]"
    data_df = pandas.read_json(data_json_str)
    return data_df

def dataFrameByUser(userId):
    with open('messages.json', 'r') as f:
        data = f.readlines()
    data = map(lambda x: x.rstrip(), data)
    data_json_str = "[" + ','.join(data) + "]"
    data_df = pandas.read_json(data_json_str)
    specific_user = data_df["user_id"] == userId
    print (specific_user)
    return data_df[specific_user]

def messageCounts(dataFrame):
    messageCount = []
    for number in range(0,451):
        messageCount.append(0)
    for message in dataFrame["text"]:
        try:
            messageLength = len(message)
        except:
            messageLength = 0
        messageCount[messageLength] = messageCount[messageLength] + 1
    plt.plot(range(1,100),messageCount[1:100])


def dateTimeCount(dataFrame):
    hours = []
    for _ in range(0,24):
        hours.append(0)
    for timeStamp in dataFrame["created_at"]:
        h = (timeStamp).hour
        hours[h] = hours[h] + 1
    plt.plot(range(0,24),hours)

def getUserIds(dataFrame):
    ids = []
    for id in dataFrame["user_id"]:
        if not ids.__contains__(id):
            ids.append(id)
    np_ids = (np.array(ids))
    return np_ids[np_ids != 'system']

def dateTimeByUser(dataFrame):
    ids = getUserIds(dataFrame)
    for id in ids:
        df = dataFrameByUser(id)
        messageCounts(df)
    plt.yscale('log')
    plt.show()

def timeBetweenMessages(dataFrame):
    lastTime = pandas.Timestamp.now()
    timeSpans = []
    for row in dataFrame["created_at"]:
        temp_time = row
        timeSpans.append(lastTime - temp_time)
        lastTime = temp_time
    seconds = []
    for delta in timeSpans:
        if delta.seconds > 1800:
            seconds.append(delta.seconds/60)
    plt.hist(seconds,100)
    plt.show()



df = dataFrame()
(timeBetweenMessages(df))
