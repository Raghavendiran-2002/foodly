import random
import string
import csv
import firebase_admin
from firebase_admin import credentials, firestore
cred = credentials.Certificate("Foodly.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

# opening the CSV file
with open('/Users/raghavendiran/Development/KC/FirestoreAutomator/Gaints.csv', mode='r')as file:

    # reading the CSV file
    csvFile = csv.reader(file)

    # displaying the contents of the CSV file
    for lines in csvFile:
        foodsRandomID = ''.join(random.choice(string.ascii_uppercase +
                                              string.ascii_lowercase + string.digits) for _ in range(25))
        foods = {
            u'categoryID': False,
            u'description': u'fan1',
            u'foodID': u'esp2',
            u'foodName': u'uid3',
            u'imageURL': False,
            u'price': u'',
            u'rating': u''
        }
        foodsCategories = {
            u'foodID': False,
            u'foodName': u'',
            u'lowResImageURL': u'esp2',
            u'price': u'uid3',
            u'shortDescription': False,
            u'rating': u''
        }

        print(lines)
        db.collection(u'foods').document(foodsRandomID).set(foods)
