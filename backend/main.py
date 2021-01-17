import datetime
from datetime import datetime
from flask import Flask, request

from extras.ocr import run_ocr
from extras.imageRetrieval import get_image
from extras.db_methods import get_all_user_items, add_item, delete_item, get_all_users
from extras.smsReminder import smsRemind

app = Flask(__name__)

@app.route('/uploadItem', methods=['POST'])
def uploadItem():
    reqJson = request.get_json(force=True)
    srcLink = reqJson['src_img']
    product_name = reqJson['barcode_text']
    username = reqJson['username']
    
    exp_date = run_ocr(srcLink)
    add_date = datetime.today().strftime('%Y-%m-%d')

    preview_img_url = get_image(product_name)

    add_item(product_name, username, add_date, exp_date, preview_img_url)
    return '1'

@app.route('/deleteItem', methods=['POST'])
def deleteItem():
    reqJson = request.get_json(force=True)
    product_id = reqJson['p_id']
    delete_item(product_id)
    return '1'

@app.route('/getAllItems', methods=['POST'])
def getAllItems():
    reqJson = request.get_json(force=True)
    username = reqJson['username']
    return (get_all_user_items(username))

def checkEveryItemForEveryUser():
    userList = get_all_user_item()
    for user in userList:
        username = user['username']
        phoneNum = user['phoneNum']
        userItems = get_all_user_items(user)
        expiredList=[]
        for item in userItems:
            
            product_name = item['product_name']
            expiry_date = item['exp_date']
            exp_date = datetime.strptime(expiry_date, '%Y-%m-%d')
            today = datetime.now()

            timeUntilExp = exp_date - today

            if (timeUntilExp.days == 3 or timeUntilExp.days == 1):
                expiredList.append(product_name)
        smsRemind(username, phoneNum, expiredList, timeUntilExp.days)

if __name__ == "__main__":
    app.run(debug=True)
