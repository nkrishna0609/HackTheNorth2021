import psycopg2, json
from psycopg2.extras import DictCursor
# Connect to Database
with open('./extras/db_creds.json', 'r') as f:
    creds = json.load(f)

connection_string = "postgres://"+creds['username']+":"+creds['password']+"@"+creds['url']+"?sslmode=verify-full&sslrootcert=extras/htn-cockroach-ca.crt"
conn = psycopg2.connect(connection_string)

print("connected to", creds['url'])

def get_all_users():
    cur = conn.cursor(cursor_Factory=DictCursor)
    cur.execute('SELECT * FROM users;')
    userList = cur.fetchall()
    return userList

def get_all_user_items(username):
    cur = conn.cursor(cursor_factory=DictCursor)
    params = {'username': username}
    data = []

    cur.execute('SELECT * FROM items WHERE username=%(username)s;', params)
    rows = cur.fetchall()
    for row in rows:
        tempData = {
            'id':row[0],
            'product_name':row[1],
            'username':row[2],
            'add_date':str(row[3]),
            'exp_date':str(row[4]),
            'preview_img_url':row[5],
        }
        data.append(tempData)
    return(str(data).replace("'",'"'))

def add_item(product_name, username, add_date, exp_date, preview_img_url):
    cur = conn.cursor()
    params = {
        'product_name':product_name,
        'username':username,
        'add_date':add_date,
        'exp_date':exp_date,
        'preview_img_url':preview_img_url
    }
    cur.execute('INSERT INTO items VALUES (gen_random_uuid (), %(product_name)s, %(username)s, %(add_date)s, %(exp_date)s, %(preview_img_url)s);', params)
    conn.commit()

def delete_item(p_id):
    cur = conn.cursor()
    params = {"id":p_id}
    cur.execute("DELETE FROM items WHERE id=%(id)s;", params)
    conn.commit()

