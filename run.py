from flask import *
import flask

app = Flask(__name__)

@app.route('/post/<name>')
@app.route('/')
def post_name(name=""):
    return send_file('index.html')

@app.route('/test')
def post_test(name=""):
    return send_file('test.html')

@app.route('/<id>')
def route_id(id):
    return flask.request.path

@app.route('/bower_components/<path:filename>')
def bower_components(filename):
    return send_from_directory('./bower_components/', filename)

@app.route('/posts/<path:filename>')
def posts(filename):
    return send_from_directory('./posts/', filename,cache_timeout=0)

@app.route('/template/<path:filename>')
def template(filename):
    return send_from_directory('./template/', filename)

#@app.route('/post/image/<path:filename>')
#def post_image(filename):
#    return send_from_directory('./posts/images/', filename, cache_timeout=0)

app.run(debug=True,host="127.0.0.1")
