import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

from algoliasearch.search_client import SearchClient

from pprint import pprint

import json


cred = credentials.Certificate('./google_secret_key.json')
firebase_admin.initialize_app(cred, {
  'projectId': 'lynight-53310',
})

db = firestore.client()

club_collection = db.collection(u'club')
clubs = club_collection.stream()

dict_clubs = []

for club in clubs:
  el = club.to_dict()
  del el['position']
  el["objectID"] = club.id
  dict_clubs.append(el)

# pprint(dict_clubs)

f = open("algolia_secret_key.txt", "r")

algolia_key = f.read()

client = SearchClient.create('OP8EZVD8YH', algolia_key)

print("debut de l'indexage dans algolia")
index = client.init_index('test_bloon_club_search')
index.save_objects(dict_clubs)

print("fin de l'indexage")


