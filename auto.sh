#!/bin/bash
#author sean
cat << EOF
**************************************
*       Welcome to my tools          *
*       Author: Sean                 *
*       Date: 2016/7/31              *
**************************************
EOF
#check the OS this script is only for CentOS 6
function check_os(){
    if(($1 == 1))
    then
        platform=`uname -i`
        if [ $platform != "x86_64" ];then
        echo "this script is only for 64bit Operating System !"
        exit 1
        fi
        echo "the platform is ok"
        version=`lsb_release -r |awk '{print substr($2,1,1)}'`
        if [ $version != 6 ];then
        echo "this script is only for CentOS 6 !"
        exit 1
        fi
    fi
}
# 1:checked  0:unchecked
check_os 0

filepath=$(cd "$(dirname "$0")"; pwd)
index=-1

function show_menus(){
cat << EOF
【System Environment】                            【Common Tools】
[1] Initialization System environment.            [9] Install Nginx1.6.
[2] Configure SSH_Auth.                           [10] Install Jdk1.7.
[3] Configure Network-bonding.                    [11] Install Maven3.3.9.
【Common Databases】                              [12] Install SVN1.8.
[4] Install MongoDB_2.6.                          [13] Install Tomcat7.
[5] Install MongoDB_3.0.                          [14] Install Tomcat8.
[6] Install MySQL.                                [15] Install Jenkins2.18.
【Network Monitoring】                            [16] Install Git1.7.1.
[7] Find Current Network-flow.                    [17] Install Memcached1.4.4.
[8] Install Url_Listening.                        [18] Install Redis.
                                                  [19] NFS-Server.
                                                  [20] NFS-Client.
[100] Show Menus.
[0] Exit.
EOF
}

show_menus
while(($index!=0))
do
  echo 'Please input index:'
  read index
  case  $index  in
    100 ) show_menus;;
    1 ) $filepath/base/sys.sh;;
    2 ) $filepath/base/ssh.sh;;
    3 ) $filepath/network/network-bonding.sh;;
    4 ) $filepath/mongodb/install_2.6.sh;;
    5 ) $filepath/mongodb/install_3.0.sh;;
    6 ) $filepath/mysql/install.sh;;
    7 ) $filepath/network/getFlow/flow.sh;;
    8 ) $filepath/listening/url_listening.sh;;
    9 ) $filepath/app/nginx/install_1.6.2.sh;;
    10 ) $filepath/app/java/install_JDK.sh;;
    11 ) $filepath/app/maven/install_3.3.9.sh;;
    12 ) $filepath/app/svn/install_1.8.sh;;
    13 ) $filepath/app/tomcat/install_7.sh;;
    14 ) $filepath/app/tomcat/install_8.sh;;
    15 ) $filepath/app/jenkins/install_2.18.sh;;
    16 ) $filepath/app/git/install_1.7.1.sh;;
    17 ) $filepath/app/memcached/install_1.4.4.sh;;
    18 ) $filepath/app/redis/install_2.8.7.sh;;
    19 ) $filepath/app/nfs_server.sh;;
    20 ) $filepath/app/nfs_client.sh;;
    * ) show_menus;;
  esac
done

cat << EOF
+-------------------------------------------------+
|  Thank you for usesing!                         |
+-------------------------------------------------+
EOF

