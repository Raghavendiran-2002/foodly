import firebase_admin
from firebase_admin import credentials, firestore
cred = credentials.Certificate("Foodly.json")
firebase_admin.initialize_app(cred)

db = firestore.client()


# s = db.collection(u'foodCategories').document().get()
docs = db.collection(u'foodCategories').stream()

for doc in docs:
    print(f'{doc.id} => {doc.to_dict()}')

# print(s)
