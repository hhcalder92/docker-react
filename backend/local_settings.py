import os

DEBUG = True
DATABASES = {
    'default': {
        'ENGINE': 'django.contrib.gis.db.backends.postgis',
        'NAME': 'amcdb',
        'USER': 'amc',
        'PASSWORD': 'artmartcity',
        'HOST': 'amcdb.cfgoob1ycwoh.us-west-2.rds.amazonaws.com',
        'PORT': '5432',
    }
}


# DEFAULT_FILE_STORAGE = 'django_settings.s3utils.MediaRootS3BotoStorage'
AWS_ACCESS_KEY_ID = ''
AWS_SECRET_ACCESS_KEY = ''
AWS_STORAGE_BUCKET_NAME = 'artmart-citytest'
AWS_S3_CUSTOM_DOMAIN = '%s.s3.amazonaws.com' % AWS_STORAGE_BUCKET_NAME

# Sends email to the console for debugging purposes, comment out for production
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'
