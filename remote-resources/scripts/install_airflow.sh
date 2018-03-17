
export AIRFLOW_HOME=~/airflow

sudo apt-get -y install gcc g++ libffi-dev libmysqlclient-dev

sudo pip install -r $( dirname "${BASH_SOURCE[0]}" )/../config/airflow_requirements.txt

airflow initdb

# Backup default config file and extract fernet key
mv $AIRFLOW_HOME/airflow.cfg $AIRFLOW_HOME/airflow.cfg.bak
fernet_key=`grep fernet_key $AIRFLOW_HOME/airflow.cfg.bak | cut -d' ' -f3`

# Create config file from template
CFG_TEMPLATE=/tmp/remote-resources/config/airflow.cfg
NOCRYPTO_MSG="cryptography_not_found_storing_passwords_in_plain_text"
cat $CFG_TEMPLATE | sed "s/$NOCRYPTO_MSG/$fernet_key/" > $AIRFLOW_HOME/airflow.cfg
