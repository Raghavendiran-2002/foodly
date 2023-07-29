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
    foodCat = ''.join(random.choice(string.ascii_uppercase +
                                    string.ascii_lowercase + string.digits) for _ in range(20))
    # displaying the contents of the CSV file
    for lines in csvFile:
        foodsRandomID = ''.join(random.choice(string.ascii_uppercase +
                                              string.ascii_lowercase + string.digits) for _ in range(20))
        # foods = {
        #     u'categoryID': False,
        #     u'description': u'fan1',
        #     u'foodID': u'esp2',
        #     u'foodName': u'uid3',
        #     u'imageURL': False,
        #     u'price': u'',
        #     u'rating': u''
        # }
        foods = {
            'imageURL': '',
            'shortDescription': '',
            'foodID': foodsRandomID,
            'foodName': lines[1],
            'lowResImageURL': '',
            'categoryID': foodCat,
            'rating': 0,
            'description': '',
            'price': lines[2]
        }
        foodsCategoriesInit = {
            # 'foods':
            #    [{'shortDescription': '',
            #      'foodName': lines[1],
            #      'rating': 0,
            #      'price': lines[2],
            #      'foodID': foodsRandomID,
            #      'lowResImageURL': ''
            #      }],
            'categoryImageURL': '',
            'categoryName':  lines[0],
            'vendorID': 'nIhlGIiIiV2YEgwuCaBK3LbYB',
            'categoryID': foodCat
        }
        foodsCategories = {u'foods': firestore.ArrayUnion(
                           [{'shortDescription': '',
                            'foodName': lines[1],
                             'rating': 0,
                               'price': lines[2],
                               'foodID': foodsRandomID,
                             'lowResImageURL': ''
                             }])
                           }

        print(lines)
        # a = 1
        # while(a):
        #     db.collection(u'foodCategoriesDummy').document(
        #         foodCat).set(foodsCategoriesInit)
        #     a = 0
        db.collection(u'foodsDummy').document(foodsRandomID).set(foods)
        db.collection(u'foodCategoriesDummy').document(u'u0G4FJwVohdD1uvAYtUp').update({u'foods': firestore.ArrayUnion(
            [{u'shortDescription': '',
              u'foodName': lines[1],
              u'rating': 0,
              u'price': lines[2],
              u'foodID': foodsRandomID,
              u'lowResImageURL': ''
              }])
        })
