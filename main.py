from google.cloud import storage
import requests
from io import BytesIO
import os
import datetime

def upload_csv_from_url(url, bucket_name, destination_blob_name):
    # Récupérer le contenu du fichier CSV depuis l'URL
    response = requests.get(url)
    if response.status_code != 200:
        print(f"Impossible de récupérer le fichier depuis l'URL {url}")
        return

    # Initialiser un client Google Cloud Storage
    client = storage.Client()

    # Récupérer le bucket
    bucket = client.bucket(bucket_name)

    # Créer un objet blob
    blob = bucket.blob(destination_blob_name)

    # Envoyer le contenu du fichier CSV vers Google Cloud Storage
    blob.upload_from_file(BytesIO(response.content), content_type='text/csv')

    print(f"Fichier CSV téléchargé depuis {url} et stocké dans gs://{bucket_name}/{destination_blob_name}")

# Exemple d'utilisation
url = "https://www.data.gouv.fr/fr/datasets/r/1b7bb850-b438-452a-bba3-cd703410a036"


destination_blob_name = "data/biomethane-" +  datetime.datetime.now().strftime('%Y-%m-%d') + ".csv" ## upload the file with the current date

upload_csv_from_url(url, os.environ.get('bucket'), destination_blob_name)
