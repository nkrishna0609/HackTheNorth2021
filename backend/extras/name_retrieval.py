import requests

from bs4 import BeautifulSoup

def get_product_from_barcode(barcode):
    url = "https://world.openfoodfacts.org/product/"+barcode
    headers=[]
    req = requests.get(url, headers)
    soup = BeautifulSoup(req.content, 'html.parser')
    return soup.find_all(attrs={"property": "food:name"})[0].text