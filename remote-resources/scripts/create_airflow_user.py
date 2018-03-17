#! /usr/bin/env python

import argparse

import airflow
from airflow import models, settings
from airflow.contrib.auth.backends.password_auth import PasswordUser

parser = argparse.ArgumentParser(description='Set Airflow username and password.')
parser.add_argument('-u', '--username', required=True, help='Airflow username to create')
parser.add_argument('-p', '--password', required=True, help='Password for the Airflow user')
args = parser.parse_args()

user = PasswordUser(models.User())
user.username = args.username
user.password = args.password

session = settings.Session()
session.add(user)
session.commit()
session.close()
