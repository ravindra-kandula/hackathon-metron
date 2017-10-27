## Accelerated PCAP Forensics Solution for HCP 1.3
### for Hortonworks Great Lakes Q4 Hackathon 

#### Purpose

The Accelerated PCAP Forensics Solution enables your company the ability to capture, scan, and analyze PCAP data, perform a detailed forensics analysis, and to better prepare you to react in a meaningful way to these threats in near real-time

#### Prerequistes

- Python 2.7+ needed to be installed

#### Install

The following script will provision a HCP instance on AWS and configure it with the latest version of the solution

```
git clone https://github.com/ravindra-kandula/hackathon-metron
cd hackathon-metron
python ./install.py -key <aws key>
```

#### Start Demo

The demo is focused on identifying susupicuous data in packets, allowing the security analyst to quickly download the associated PCAP's

```
./pcap/replay.sh
```
