# pip install google.cloud

import os, io, re, datetime
import string
from google.cloud import vision

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = r"creds.json"

regex_types = [ "[a-zA-Z]{3}[0-9]{2}",    # JAN10
                "[a-zA-Z]{3}\s+[0-9]{2}", # JAN 10
                ]

month_abbreviations = [ "JAN", "FEB", "MAR", 
                        "APR", "MAY", "JUN", 
                        "JUL", "AUG", "SEP", 
                        "OCT", "NOV", "DEC"
                        ]
bad_printing_errors =   { 
    'B':['P','S'],      'C':['G'],
    'D':['O'],          'E':['F'],
    'F':['R','E'],      'G':['C'], 
    'I':['L'],          'L':['I'],
    'M':['N'],          'N':['M'], 
    'O':['O','U'],      'P':['B'],
    'R':['F'],          'S':['B'],
    'T':['I'],          'U':['O','U'],
    'V':['U','W'],      'W':['V'], 
    'X':['Y'],          'Y':['X'], 

    '0':['8'],          '1':['7'],
    '3':['9','8','5'],  '4':['9'],
    '5':['8','3'],      '6':['8'],
    '7':['1'],          '8':['0','3','5','6'], 
    '9':['3','4']
}

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
        match = re.search(i, ocr_str)
        if match:
            return(match.group(0))

def correct_text(filtered_str):
    filtered_str = filtered_str.replace(" ","")
    month=filtered_str[:3]
    date=filtered_str[3:]
    if month not in month_abbreviations:
        split_month = list(month)
        # print(split_month)
        for i in range(0,len(split_month)):
            confused_chars=bad_printing_errors[split_month[i]]
            for j in confused_chars:
                temp_str = split_month
                temp_str[i] = j
                if ("".join(temp_str)) in month_abbreviations:
                    month = "".join(temp_str)
                    break
    if int(date) > 31:
        split_date = list(date)
        for i in range(0, len(split_date)):
            confused_ints=bad_printing_errors[split_date[i]]
            for j in confused_ints:
                temp_str = split_date
                temp_str[i] = j
                if(int("".join(temp_str))<=31):
                    date = "".join(temp_str)
                    break
    return (month, date)


# filter_text("FEB 17sdf")
correct_text(filter_text(detect_text("imgs/img4.jpg")))
# filter_text(detect_text("imgs/img2.jpg"))
# filter_text(detect_text("imgs/img3.jpg"))
# filter_text(detect_text("imgs/img5.jpg"))
# detect_text("imgs/img2.jpg")
# detect_text("imgs/img3.jpg")
# detect_text("imgs/img4.jpg")
# detect_text("imgs/img5.jpg")
