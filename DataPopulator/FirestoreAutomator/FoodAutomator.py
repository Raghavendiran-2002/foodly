import firebase_admin
from firebase_admin import credentials, firestore
cred = credentials.Certificate("Foodly.json")
firebase_admin.initialize_app(cred)

db = firestore.client()
# data = {
#     u'foods': False,
#     u'deviceName': u'fan1',
#     u'devicePath': u'esp2',
#     u'deviceUID': u'uid3',
#     u'isTransient': False,
#     u'parentEsp': u'esp2',
#     u'targetState': False
# }
# u'categoryID': False,

doc = db.collection(u'foods').document(u'lBTClPdz8kQ5SDkVzzVP').get()
if doc.exists:
    print(doc.to_dict())
# db.collection(u'foods').document(u'DpY5of4AAZrLjDOMArDD').update(
#     {u'foods': firestore.ArrayUnion([{u'foodName': '', u'foodID': ''}])})
