#!flask/bin/python
# coding=utf-8
from flask import Flask, jsonify

app = Flask(__name__)

tasks = [
    {
  "event_id" : "1.4",
  "introductions" : [
    {
      "title" : "情怀",
      "details" : "各种无敌， 各种牛人， 各种挑战， 等你来战",
      "image" : "hello.png",
      "background_image" : "backgroundImage.png"
    },
    {
      "title" : "钉子",
      "details" : "各种硬， 各种尖， 各种钻， 钉子精神",
      "image" : "hello.png",
      "background_image" : "backgroundImage.png"
    }
  ]
}
]

@app.route('/todo/api/v1.0/tasks', methods=['GET'])
def get_tasks():
    return jsonify({'tasks': tasks})

if __name__ == '__main__':
    app.run(debug=True)