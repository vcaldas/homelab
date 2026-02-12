# Home Network VLANS

VLAN | NAME       | SUBNET       | PURPOSE
---- | ---------- | ------------ | -------
1    | MANAGEMENT | 10.1.1.0/16  | Network devices management. Router, AP, etc
10   | HOME       | 10.10.0.0/16 | General home devices.
20   | SERVERS    | 10.20.0.0/16 | Virtual machines and container workloads.
30   | IOT        | 10.30.0.0/16 | Home servers and NAS devices.
40   | GUEST      | 10.40.0.0/16 | Guest devices and networks.
70   | DMZ        | 10.70.0.0/16 | Public-facing services and applications.
60   | KIDS       | 10.60.0.0/16 | Children's devices with restricted access.

# VLAN Configuration

Management Network

- VLAN ID: 1
Devices:
    Unifi Router: 10.1.1.2
    Unifi AP: 10.1.10.1
    Unifi AP2: 10.1.10.2

