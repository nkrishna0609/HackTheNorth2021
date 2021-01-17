from flask import Flask, request

from extras.ocr import run_ocr
from extras.imageRetrieval import get_image
from extras.db_methods import get_all_user_items, add_item, delete_item

app = Flask(__name__)

@app.route('/expiryDate', methods=['POST'])
def expiryDateRetrieval():
    reqJson = request.get_json(force=True)
    srcLink = reqJson['src_img']
    expiryDate=run_ocr(srcLink)
    return str(expiryDate)

@app.route('/image', methods=['POST'])
def imageRetrieval():
    reqJson = request.get_json(force=True)
    imageQuery = reqJson['barcode_text']
    imageLink = get_image(imageQuery)
    return imageLink

if __name__ == "__main__":
    app.run(debug=True)
