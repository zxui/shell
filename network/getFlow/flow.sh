#!/bin/bash

awk 'BEGIN{
OFMT="%.3f";
devf="/proc/net/dev";
while(("cat "devf) | getline)
{
    if($0 ~ /:/ && ($10+0) > 0)
    {
        split($1,tarr,":");
        net[tarr[1]]=$10+tarr[2];
        print tarr[1],$10+tarr[2];
    }
}
close(devf);
while((system("sleep 1 ")) >=0)
{
    system("clear");
    while( getline < devf )
    {
        if($0 ~ /:/ && ($10+0) > 0)
            {
                split($1,tarr,":");
                if(tarr[1] in net)
                {
                    print tarr[1],":",($10+tarr[2]-net[tarr[1]])*8/1024,"kb/s";
                    net[tarr[1]]=$10+tarr[2];
                }
            }
    }
    close(devf);
}
}'