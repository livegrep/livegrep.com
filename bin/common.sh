set -eu

instance_hostname () {
    local instance=$1
    host=''
    while test -z "$host"; do
        host=$(aws ec2 describe-instances \
                   --instance-ids $instance \
                   --query 'Reservations[0].Instances[0].PublicDnsName' \
                   --output=text)
    done
    echo "$host"
}
