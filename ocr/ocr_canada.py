# pip install google.cloud

import os, io, re, datetime
import string
from google.cloud import vision

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = r"creds.json"

regex_types = [ (0, "([a-zA-Z]{2}[0-9]{2})"),             # JA10
                (1, "([a-zA-Z]{2} [0-9]{2})"),            # JA 10
                (2, "([0-9]{2}[a-zA-Z]{2}[0-9]{2})"),     # 21JA10
                (3, "([0-9]{2} [a-zA-Z]{2} [0-9]{2})"),   # 21 JA 10
                (4, "([0-9]{4}[a-zA-Z]{2}[0-9]{2})"),     # 2021JA10
                (5, "([0-9]{4} [a-zA-Z]{2} [0-9]{2})"),   # 2021 JA 10
                ]

month_abbreviations = { "JA":1, "FE":2, "MR":3, 
                        "AL":4, "MA":5, "JN":6, 
                        "JL":7, "AU":8, "SE":9, 
                        "OC":10,"NO":11,"DE":12}

def detect_text(path):
    """Detects text in the file."""
    client = vision.ImageAnnotatorClient()

    with io.open(path, 'rb') as image_file:
        content = image_file.read()

    image = vision.Image(content=content)

    response = client.text_detection(image=image)
    texts = response.text_annotations

    if response.error.message:
        raise Exception(
            '{}\nFor more info on error messages, check: '
            'https://cloud.google.com/apis/design/errors'.format(
                response.error.message))
    # print(texts[0].description)
    return(texts[0].description)

def filter_text(ocr_str):
    for i in regex_types:
        match = re.search(i[1], ocr_str)
        if match:
            return(match.group(0), i[0])

def convert_to_date(matched_str, mode):
    matched_str=matched_str.replace(" ", "")
    year = ""
    month = ""
    day = ""
    if mode == 0 or mode == 1:
        year = str(datetime.datetime.now().year)
        month = matched_str[:2]
        day = matched_str[2:]
    elif mode == 2 or mode == 3:
        year = "20"+matched_str[:2]
        month = matched_str[2:4]
        day = matched_str[4:]
    elif mode == 4 or mode == 5:
        year = matched_str[:4]
        month = matched_str[4:6]
        day = matched_str[6:]
    
    try:
        month_int = month_abbreviations[month]
        date = datetime.datetime(int(year), month_int, int(day))
        return date

    except KeyError as e:
        return "whoops that didnt work did it"
        
text, mode = filter_text(detect_text("imgs/img_0.jpg"))
print(convert_to_date(text,mode))
text, mode = filter_text(detect_text("imgs/img_1.jpg"))
print(convert_to_date(text,mode))
text, mode = filter_text(detect_text("imgs/img_2.jpg"))
print(convert_to_date(text,mode))
text, mode = filter_text(detect_text("imgs/img_3.jpg"))
print(convert_to_date(text,mode))
text, mode = filter_text(detect_text("imgs/img_4.jpg"))
print(convert_to_date(text,mode))