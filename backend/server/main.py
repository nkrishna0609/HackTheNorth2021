import datetime, time, os
from datetime import datetime
from flask import Flask, request, render_template

from extras.ocr import run_ocr
from extras.imageRetrieval import get_image
from extras.db_methods import get_all_user_items, add_item, delete_item, get_all_users
from extras.smsReminder import smsRemind
from extras.name_retrieval import get_product_from_barcode

app = Flask(__name__)

def format_server_time():
  server_time = time.localtime()
  return time.strftime("%I:%M:%S %p", server_time)

@app.route('/')
def index():
    context = { 'server_time': format_server_time() }
    return render_template('index.html', context=context)

@app.route('/uploadItem', methods=['POST'])
def uploadItem():
    reqJson = request.get_json(force=True)
    srcLink = reqJson['src_img']
    username = reqJson['username']
    
    exp_date = run_ocr(srcLink)
    add_date = datetime.today().strftime('%Y-%m-%d')

    product_name = get_product_from_barcode(reqJson['barcode_text'])
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
    userList = get_all_user_items()
    for user in userList:
        username = user['username']
        userItems = get_all_user_items(user)
        expiredList=[tuple()]
        for item in userItems:
            
            product_name = item['product_name']
            expiry_date = item['exp_date']
            exp_date = datetime.strptime(expiry_date, '%Y-%m-%d')
            today = datetime.now()

            timeUntilExp = exp_date - today

            if (timeUntilExp.days == 3 or timeUntilExp.days == 1):
                expiredList.append((product_name,expiry_date))
                
        smsRemind(username, expiredList, timeUntilExp.days)

# if __name__ == '__main__':
#     app.run(debug=True,host='0.0.0.0',port=int(os.environ.get('PORT', 8080)))