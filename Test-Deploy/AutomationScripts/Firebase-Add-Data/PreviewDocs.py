import firebase_admin
from firebase_admin import credentials, firestore
cred = credentials.Certificate("Foodly.json")
firebase_admin.initialize_app(cred)

db = firestore.client()


# docs = db.collection(u'foodCategories').stream()
docs = db.collection(u'foods').stream()

for doc in docs:
    print(f'{doc.id} => {doc.to_dict()}')
