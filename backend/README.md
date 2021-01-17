# HackTheNorth2021

To deploy:

`cd server/`
`gcloud builds submit --tag gcr.io/hackthenorth2020-301910/flask-firebase`
`gcloud beta run deploy --image gcr.io/hackthenorth2020-301910/flask-firebase --platform managed`
