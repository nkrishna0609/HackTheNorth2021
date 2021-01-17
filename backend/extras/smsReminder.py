import nexmo
import datetime
from datetime import datetime

#Vonage API Credentials
client = nexmo.Client(key='0d4d7610', secret='zLAyx80JXXbjY09k')

def smsRemind(name, phoneNum, productList, daysUntilExp):
    entireStringOfProducts=",".join(productList)
    
    client.send_message({
        'from': '14036687449',
        'to': str(phoneNum),
        'text': 'Hey ' + name + '. These item(s) will expire in ' + str(daysUntilExp) + ' day(s): ' + entireStringOfProducts,
    })
