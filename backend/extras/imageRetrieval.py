import random, urllib.request, os, time
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager

options=Options()
options.add_argument('--disable-gpu')
options.add_argument('--no-sandbox')
options.add_argument("--headless")
driver=webdriver.Chrome(ChromeDriverManager().install(), chrome_options = options)
# --------------------------------------------------------

# Retrieve first image src from google images based on query
def get_image(query):
    url = "https://www.google.com/search?q="+query+"&source=lnms&tbm=isch"
    try:
        driver.get(url)
    except Exception as e:
        print(e)

    # Google image web site logic
    elements = driver.find_elements_by_class_name('rg_i')

    first_image = elements[0]
    first_image.click()
    time.sleep(1)
    element = driver.find_elements_by_class_name('v4dQwb')

    big_img = element[0].find_element_by_class_name('n3VNCb')
    img_src = big_img.get_attribute("src") 

    # Handle both https links and base64 links
    if "https" in img_src and len(img_src) < 2000:
        return(img_src)
