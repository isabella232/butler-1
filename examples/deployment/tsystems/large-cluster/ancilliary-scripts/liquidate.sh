for pid in `ps auxww | grep wildish | egrep '[s]sh-agent' | awk '{ print $2 }'`
do
  echo $pid
  kill $pid
done

ssh-agent -s | tee ~/.agent
source ~/.agent

ssh-add ~/.ssh/id_rsa.ebi
