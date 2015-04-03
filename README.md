# parse-uploader
Batch file uploader for Parse.com apps

## Usage

Set the following envrionment variables for your app (available in Settings > Keys): 

* PARSE_APP_ID
* PARSE_API_KEY
* PARSE_MASTER_KEY

(optional) create a config.yml file that specifies the other column names / values 

_Example_: ruby parse_upload.rb *.png --class Animal --col photo
