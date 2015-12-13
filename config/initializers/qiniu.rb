require 'qiniu'

QINIU_CONFIG = YAML.load_file(Rails.root.join('config', 'qiniu.yml'))[Rails.env]
Qiniu.establish_connection! access_key: QINIU_CONFIG[:accessKey], secret_key: QINIU_CONFIG[:appSecret]

