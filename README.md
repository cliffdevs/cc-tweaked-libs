# ComputerCraft Tools for FTB
This is a repo of ComputerCraft programs to integrate together for FTB operations.

```mermaid
flowchart LR
    cfgstore

    subgraph lumberjacks
        l1[lumberjack1]
        l2[lumberjack2]
        l3[lumberjack3]
    end

    subgraph miners
    m1[miner1]
    m2[miner2]
    m3[miner3]
    end

    subgraph refuelers
    r1[refueler1]
    r2[refueler2]
    r3[refueler3]
    end

    subgraph retrievers
    re1[retriever1]
    re2[retriever2]
    re3[retriever3]
    end

    lumberjacks -->| get work input| cfgstore
    miners -->| get work input| cfgstore
    refuelers -->| register for work| cfgstore
    cfgstore -->| tell worker refuel| refuelers
    lumberjacks -->| get work input| cfgstore
    retrievers -->| register for work| cfgstore
    cfgstore -->| tell to retrieve| retrievers

    retrievers --> miners
    retrievers --> lumberjacks

    refuelers --> miners

    refuelers --> storage
    retrievers --> storage
```

## Cfg-Store
This is an 'API' to hold distributed configuration. It will contain info like:
- Refuel Inventory Stations per dimension / task / turtle
- Program specific config maps (custom)
- Registration of worker ids per program for distributed discovery

## Lumberjack
This program will cut trees and replant them infinitely while storing the excess for the team.

## Miner
This program will quarry the configured area and exchange items for fuel with refuelers

## Refueler
This program will transport fuel from storage to the worker to allow them to keep doing their thing

## Retriever
This program will find workers and take their inventory back to storage
