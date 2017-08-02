#!/usr/bin/env python3.6

import os
import uuid

from flask import Flask
from flask import flash
from flask import redirect
from flask import render_template
from flask import request
from flask_bootstrap import Bootstrap
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = '/uploads'

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 128 * 1024 * 1024
app.secret_key = ''
bootstrap = Bootstrap(app)


@app.route('/', methods=['GET'])
def index():
    return render_template('index.html')


@app.route('/email', methods=['GET', 'POST'])
def email():
    if request.method == 'POST':

        # Check if the post request has the text part
        if 'text' not in request.form:
            flash('No text part', category='error')
            return redirect(request.url)

        text = request.form['text']

        # Flash an error if user does not enter an email
        if text == '':
            flash('No email text entered', category='error')
            return redirect(request.url)

        # Save the uploaded raw email to the upload folder
        if text:
            filename = 'email_{}'.format(str(uuid.uuid4()))
            fh = open(os.path.join(app.config['UPLOAD_FOLDER'], filename), 'w')
            fh.write(text)
            fh.close()
            flash('Raw email uploaded {}'.format(filename), category='info')
            return redirect(request.url)

    return render_template('email.html')


@app.route('/file', methods=['GET', 'POST'])
def file():
    if request.method == 'POST':

        # Check if the post request has the file part
        if 'file' not in request.files:
            flash('No file part', category='error')
            return redirect(request.url)

        file = request.files['file']

        # Flash an error if user does not select file
        if file.filename == '':
            flash('No selected file', category='error')
            return redirect(request.url)

        # Save the uploaded file to the upload folder
        if file:
            filename_base = secure_filename(file.filename)
            filename = '{}_{}'.format(str(uuid.uuid4()), filename_base)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            flash('File uploaded {}'.format(filename), category='info')
            return redirect(request.url)

    return render_template('file.html')


@app.route('/help', methods=['GET'])
def help_main():
    return render_template('help.html')


@app.route('/help/gmail', methods=['GET'])
def gmail():
    return render_template('gmail.html')


@app.route('/help/yahoo', methods=['GET'])
def yahoo():
    return render_template('yahoo.html')


@app.route('/help/apple_mail', methods=['GET'])
def apple_mail():
    return render_template('apple_mail.html')

if __name__ == "__main__":
    app.run()
