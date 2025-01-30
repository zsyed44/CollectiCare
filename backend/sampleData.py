# THE FOLLOWING CODE IS FOR TESTING PURPOSES ONLY, RELIES ON THE REST API TO BE SET UP BEFORE WE CAN START QUERYING TO THE DB

import requests
import json
import base64

#CONFIG
BASE_URL = "http://localhost:2480" #OrientDB Default Server URL
DB_NAME = "CollectiCare"
USERNAME = "root"
# PASSWORD = "" # ADD YOUR PASSWORD HERE WHEN QUERYING DB

auth_header = {
    "Authorization": "Basic " + base64.b64encode(f"{USERNAME}:{PASSWORD}".encode()).decode()
}

def populateDB():
    # The patient table should exist on the DB, if not, run CREATE CLASS Patient EXTENDS V;
    query = "INSERT INTO Patient SET name='Alice', age=25, id=1234"
    response = requests.post(f"{BASE_URL}/command/{DB_NAME}/sql/{query}", headers=auth_header, data={"command": query})
    
    if response.status_code == 200:
        print("Record inserted:", response.json())
    else:
        print("Error inserting record:", response.text)

def getPerson():
    query = "SELECT * FROM Person"
    response = requests.post(f"{BASE_URL}/query/{DB_NAME}/sql/{query}", headers=auth_header, data={"command": query})
    
    if response.status_code == 200:
        print("Person:", response.json())
    else:
        print("Error getting person:", response.text)

if __name__ == "__main__":
    populateDB()
    getPerson()