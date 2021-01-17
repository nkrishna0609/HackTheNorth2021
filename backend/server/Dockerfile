# 1 Python Docker Image
FROM python:3.8

# 2 Install Chrome Dependencies
RUN apt-get update 
RUN apt-get install -y gconf-service libasound2 libatk1.0-0 libcairo2 libcups2 libfontconfig1 libgdk-pixbuf2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libxss1 fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils

# 3 Download and Install Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install

# 4 Install Flask and API Dependencies
COPY requirements.txt /opt/app/requirements.txt
WORKDIR /opt/app
RUN pip install -r requirements.txt
COPY . /opt/app

# 5 Copy Server Files
COPY src/ /app
WORKDIR /app

# 6 Bind Port
ENV PORT 8080

# 7 Run Gunicorn with Flask Worker
CMD exec gunicorn --bind :$PORT --workers 2 --threads 8 app:app