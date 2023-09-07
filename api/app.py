from flask import Flask, request, jsonify
from pymongo import MongoClient

app = Flask(__name__)

# MongoDB setup
client = MongoClient(
    "mongodb+srv://mongouser:qNigNxMmItaKmUr1@dev-mongo-cluster.2lrx5h2.mongodb.net/?retryWrites=true&w=majority"
)

db = client["mydatabase"]
collection = db["items"]


@app.route("/")
def home():
    response = jsonify({"msg": "Welcome to Newlook api"})
    response.headers.add("Access-Control-Allow-Origin", "*")
    return response, 200


@app.route("/health")
def health():
    response = jsonify({"Ready": True})
    response.headers.add("Access-Control-Allow-Origin", "*")
    return response, 200


@app.route("/items", methods=["GET"])
def get_items():
    items = list(collection.find({}, {"_id": 0}))
    return jsonify({"items": items})


@app.route("/items/<item_id>", methods=["GET"])
def get_item(item_id):
    item = collection.find_one({"id": int(item_id)}, {"_id": 0})
    if item:
        return jsonify(item)
    return jsonify({"message": "Item not found"}), 404


@app.route("/items", methods=["POST"])
def create_item():
    data = request.get_json()
    item_id = collection.count_documents({}) + 1
    data["id"] = item_id
    collection.insert_one(data)
    return jsonify({"message": "Item created successfully"})


@app.route("/items/<item_id>", methods=["PUT"])
def update_item(item_id):
    data = request.get_json()
    collection.update_one({"id": int(item_id)}, {"$set": data})
    return jsonify({"message": "Item updated successfully"})


@app.route("/items/<item_id>", methods=["DELETE"])
def delete_item(item_id):
    collection.delete_one({"id": int(item_id)})
    return jsonify({"message": "Item deleted successfully"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
