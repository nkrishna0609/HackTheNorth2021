import nexmo, json
import datetime
from datetime import datetime

with open('./extras/vonage_creds.json', 'r') as f:
    creds = json.load(f)

#Vonage API Credentials
client = nexmo.Client(key=creds['key'], secret=creds['secret'])

def smsRemind(name, productList, daysUntilExp):
    entireStringOfProducts=",".join(productList)
    
    client.send_message({
        'from': '14036687449',
        'to': str(name),
        'text': 'Hello from ShelfLife! The following item(s) will expire soon:' + str(daysUntilExp) + ' day(s): ' + entireStringOfProducts,
    })
