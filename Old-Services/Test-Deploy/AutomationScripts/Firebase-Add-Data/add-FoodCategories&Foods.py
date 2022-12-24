import random
import string
import csv
import firebase_admin
from firebase_admin import credentials, firestore
cred = credentials.Certificate("Foodly.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

vendorID = 'nIhlGIiIiV2YEgwuCaBK3LbYB'
a = 1

# opening the CSV file
with open('/Users/raghavendiran/Development/KC/FirestoreAutomator/Gaints.csv', mode='r')as file:

    # reading the CSV file
    csvFile = csv.reader(file)
    foodCategoryUniqueID = ''.join(random.choice(string.ascii_uppercase +
                                                 string.ascii_lowercase + string.digits) for _ in range(20))
    # displaying the contents of the CSV file
    for lines in csvFile:
        foodUniqueID = ''.join(random.choice(string.ascii_uppercase +
                                             string.ascii_lowercase + string.digits) for _ in range(20))

        foods = {
            'imageURL': '',
            'shortDescription': '',
            'foodID': foodUniqueID,
            'foodName': lines[1],
            'lowResImageURL': '',
            'categoryID': foodCategoryUniqueID,
            'rating': 0,
            'description': '',
            'price': lines[2]
        }
        foodsCategoriesInit = {
            'categoryImageURL': '',
            'categoryName':  lines[0],
            'vendorID': vendorID,
            'categoryID': foodCategoryUniqueID
        }

        while(a):
            db.collection(u'foodCategoriesDummy').document(
                foodCategoryUniqueID).set(foodsCategoriesInit)
            a = 0
        db.collection(u'foodsDummy').document(foodUniqueID).set(foods)
        #   Addes new food under foods array
        db.collection(u'foodCategoriesDummy').document(foodCategoryUniqueID).update({u'foods': firestore.ArrayUnion(
            [{u'shortDescription': '',
              u'foodName': lines[1],
              u'rating': 0,
              u'price': lines[2],
              u'foodID': foodUniqueID,
              u'lowResImageURL': ''
              }])
        })
