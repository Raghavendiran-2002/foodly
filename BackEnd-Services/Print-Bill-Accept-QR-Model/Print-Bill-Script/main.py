from google.cloud import firestore
from reportlab.pdfgen import canvas
import datetime
import threading
from time import sleep
import firebase_admin
from firebase_admin import credentials
import os
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "cred.json"
cred = credentials.Certificate("cred.json")
firebase_admin.initialize_app(cred)


db = firestore.Client()


# Create an Event for notifying main thread.
callback_done = threading.Event()

# Create a callback on_snapshot function to capture changes


def on_snapshot(col_snapshot, changes, read_time):
    print(u'Callback received query snapshot.')
    print(u'Current cities in California:')
    for doc in col_snapshot:
        print(f'{doc.id}')
    callback_done.set()


col_query = db.collection(u'cities').where(u'state', u'==', u'CA')

# Watch the collection query
query_watch = col_query.on_snapshot(on_snapshot)
